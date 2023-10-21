import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logics/bloc/user_profile/user_profile_page_bloc.dart';
import '../../../../business_logics/bloc/user_profile/user_profile_page_event.dart';
import '../../../../business_logics/bloc/user_profile/user_profile_page_state.dart';
import '../../../custom_widgets/custom_text_field.dart';
import '../../../utilities/color_constant.dart';

class LastNameTextFieldWidget extends StatelessWidget {
  const LastNameTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProfilePageBloc userProfilePageBloc =
    BlocProvider.of<UserProfilePageBloc>(context);

    return BlocBuilder<UserProfilePageBloc, UserProfilePageState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.person_pin_sharp),
                    Text(
                      "Last name:",
                    ),
                  ],
                ),
              ),
            ),
            CustomTextField(
              isEnabled: true,
              onInputText: (_) {
                userProfilePageBloc.add(LastNameValidationEvent());
              },
              inputType: TextInputType.name,
              inputAction: TextInputAction.next,
              elevation: 0.0,
              textEditingController:
              userProfilePageBloc.lastNameTextEditingController,
              focusNode: userProfilePageBloc.lastNameFocusNode,
              hintText: 'First name',
              borderColor: state.lastNameErrorMsg.isEmpty
                  ? null
                  : ColorConstant.kRedColor,
            ),
            Visibility(
              visible: userProfilePageBloc.state.lastNameErrorMsg.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    userProfilePageBloc.state.lastNameErrorMsg,
                    style: const TextStyle(
                      color: ColorConstant.kRedColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
