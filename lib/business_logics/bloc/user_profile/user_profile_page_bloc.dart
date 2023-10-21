import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/business_logics/bloc/user_profile/user_profile_page_event.dart';
import 'package:flutter_application_1/business_logics/bloc/user_profile/user_profile_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/api_handling/user_service.dart';
import '../../../data/models/user_model/user_model.dart';

class UserProfilePageBloc
    extends Bloc<UserProfilePageEvent, UserProfilePageState> {
  final UserService _userService = UserService();
  UserModel? _userModel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final String _jwt;

  final List<String> items = ['Alumnus', '12', '11', '10', '9', '8', '7', '6'];

  final TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final TextEditingController mailTextEditingController =
      TextEditingController();
  final FocusNode mailFocusNode = FocusNode();

  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();

  final TextEditingController lastNameTextEditingController =
  TextEditingController();
  final FocusNode lastNameFocusNode = FocusNode();

  final TextEditingController addressEditingController =
      TextEditingController();
  final FocusNode addressFocusNode = FocusNode();

  final TextEditingController schoolTextEditingController =
      TextEditingController();
  final FocusNode schoolFocusNode = FocusNode();

  final TextEditingController gradeTextEditingController =
      TextEditingController();
  final FocusNode gradeFocusNode = FocusNode();

  UserProfilePageBloc(super.initialState) {
    on<FirstNameValidationEvent>(_onFirstNameValidationEvent);
    on<LastNameValidationEvent>(_onLastNameValidationEvent);
    on<PhoneValidationEvent>(_onPhoneNumberValidationEvent);
    on<SchoolValidationEvent>(_onSchoolValidationEvent);
    on<GradeValidationEvent>(_onGradeValidationEvent);
    on<AddressValidationEvent>(_onAddressValidationEvent);
    on<BackgroundTapEvent>(_onBackgroundTapEvent);
    on<SaveButtonEvent>(_onContinueButtonEvent);
    on<GradeChangeEvent>(_onGradeChangeEvent);
    on<InitEvent>(_onInitEvent);
    on<SignOutEvent>(_onSignOutEvent);

    add(InitEvent());
  }

  _onSignOutEvent(
      SignOutEvent event, Emitter<UserProfilePageState> emit) async {
    emit(state.updateStateWith(isInit: true));
    await _storage.deleteAll();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    event.navigatorToSignInPage();
  }

  _onInitEvent(InitEvent event, Emitter<UserProfilePageState> emit) async {
    _jwt = (await _storage.read(key: 'jwt'))!;
    _userModel = await _userService.fetchUserProfile(jwt: _jwt);
    String? grade;

    if (_userModel != null) {
      mailTextEditingController.text = _userModel!.email;
      firstNameTextEditingController.text = _userModel!.firstName;
      lastNameTextEditingController.text = _userModel!.lastName;
      phoneNumberTextEditingController.text = _userModel!.phone ?? '';
      schoolTextEditingController.text = _userModel!.college ?? '';
      addressEditingController.text = _userModel!.address ?? '';
      // if (_userModel!.grade!.isNotEmpty) {
      //   grade = _userModel!.grade;
      // }
    }

    emit(state.updateStateWith(isInit: false, selectedGrade: grade));
  }

  _onFirstNameValidationEvent(
      FirstNameValidationEvent event, Emitter<UserProfilePageState> emit) {
    String firstNameErrorMsg = '';
    if (firstNameTextEditingController.text.isEmpty) {
      firstNameErrorMsg = 'First name field can\'t be empty';
    }
    emit(
      state.updateStateWith(
        firstNameErrorMsg: firstNameErrorMsg,
        isChange: firstNameTextEditingController.text != _userModel?.firstName ||
            state.isChange,
      ),
    );
  }

  _onLastNameValidationEvent(
      LastNameValidationEvent event, Emitter<UserProfilePageState> emit) {
    String lastNameErrorMsg = '';
    if (lastNameTextEditingController.text.isEmpty) {
      lastNameErrorMsg = 'Last name field can\'t be empty';
    }
    emit(
      state.updateStateWith(
        lastNameErrorMsg: lastNameErrorMsg,
        isChange: lastNameTextEditingController.text != _userModel?.firstName ||
            state.isChange,
      ),
    );
  }

  _onPhoneNumberValidationEvent(
      PhoneValidationEvent event, Emitter<UserProfilePageState> emit) {
    emit(
      state.updateStateWith(
        isChange:
            phoneNumberTextEditingController.text == _userModel?.phone ||
                state.isChange,
      ),
    );
  }

  _onSchoolValidationEvent(
      SchoolValidationEvent event, Emitter<UserProfilePageState> emit) {
    emit(
      state.updateStateWith(
        isChange: schoolTextEditingController.text != _userModel?.college ||
            state.isChange,
      ),
    );
  }

  _onGradeValidationEvent(
      GradeValidationEvent event, Emitter<UserProfilePageState> emit) {}

  _onAddressValidationEvent(
      AddressValidationEvent event, Emitter<UserProfilePageState> emit) {
    emit(
      state.updateStateWith(
        isChange: addressEditingController.text != _userModel?.address ||
            state.isChange,
      ),
    );
  }

  _onContinueButtonEvent(
      SaveButtonEvent event, Emitter<UserProfilePageState> emit) async {
    if (state.firstNameErrorMsg.isEmpty || state.lastNameErrorMsg.isEmpty) {
      _unFocusAll();

      emit(state.updateStateWith(isWaitingUpdateProfile: true));

      UserModel? userModel = await _userService.updateProfile(
        jwt: _jwt,
        firstName: firstNameTextEditingController.text,
        lastName: lastNameTextEditingController.text,
        mail: mailTextEditingController.text,
        address: addressEditingController.text,
        grade: state.selectedGrade,
        phoneNumber: phoneNumberTextEditingController.text,
        school: schoolTextEditingController.text,
      );
      if (userModel != null) {
        emit(
          state.updateStateWith(
            isWaitingUpdateProfile: false,
            isChange: false,
          ),
        );
        Fluttertoast.showToast(
            msg: 'Update use profile successfully!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 17, 207, 144),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        emit(state.updateStateWith(
          isWaitingUpdateProfile: false,
          isChange: true,
        ));
        Fluttertoast.showToast(
            msg: 'Update use profile failed!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 207, 64, 17),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  _onGradeChangeEvent(
      GradeChangeEvent event, Emitter<UserProfilePageState> emit) {
    emit(
      state.updateStateWith(
        selectedGrade: event.grade,
        isChange: event.grade != _userModel?.dayOfBirth || state.isChange,
      ),
    );
  }

  _onBackgroundTapEvent(
      BackgroundTapEvent event, Emitter<UserProfilePageState> emit) {
    _unFocusAll();
  }

  _unFocusAll() {
    phoneNumberFocusNode.unfocus();
    firstNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();
    schoolFocusNode.unfocus();
    gradeFocusNode.unfocus();
    addressFocusNode.unfocus();
  }
}
