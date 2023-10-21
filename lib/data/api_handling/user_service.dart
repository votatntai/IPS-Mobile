import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/data/api_handling/api_path_constant.dart';
import 'package:flutter_application_1/data/models/user_model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;

class UserService {
  UserService._internalConstructor();

  static final UserService _instance = UserService._internalConstructor();

  factory UserService() {
    return _instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await _googleSignIn.signIn();
  }

  Future<User?> signInToFirebase(
      GoogleSignInAuthentication googleSignInAuthentication) async {
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);

      return userCredential.user;
    } on FirebaseException catch (_) {
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> signOutFirebase() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> signInToApp({required String idToken}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json-patch+json',
      };
      Map<String, dynamic> body = {'idToken': idToken};
      var jsonBody = jsonEncode(body);
      final response = await http.post(
          Uri.parse(APIPathConstant.API_SERVER_PATH + '/api/auth/google/student'),
          headers: headers,
          body: jsonBody);
      final Map<String, dynamic> data =
      json.decode(response.body);
      var accessToken = data['accessToken'];
      switch (response.statusCode) {
        case 200:
          return getAccount(json.decode(response.body), accessToken);
        case 201:
          return getAccount(json.decode(response.body), accessToken);
        default:
          return null;
      }
    } catch (e) {}
  }

  Future<UserModel?> register({
    required String idToken,
    required String name,
    required String mail,
    String? phoneNumber,
    String? school,
    String? grade,
    String? address,
  }) async {
    final http.Response response = await http.post(
      Uri.http(APIPathConstant.API_SERVER_PATH, '/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'email': mail,
        'grade': grade ?? '',
        'birthDate': '',
        'phoneNumber': phoneNumber ?? '',
        'school': school ?? '',
        'address': address ?? '',
        'accessToken': idToken,
      }),
    );

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return getAccount(json.decode(response.body), idToken);
      default:
        return null;
    }
  }

  Future<UserModel?> updateProfile({
    required String jwt,
    required String firstName,
    required String lastName,
    required String mail,
    String? phoneNumber,
    String? school,
    String? grade,
    String? address,
  }) async {
    final http.Response response = await http.put(
      Uri.http(APIPathConstant.API_SERVER_PATH, '/api/v1/auth/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName' : lastName,
        'email': mail,
        'grade': grade ?? '',
        'birthDate': '',
        'phoneNumber': phoneNumber ?? '',
        'school': school ?? '',
        'address': address ?? '',
      }),
    );
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return getAccount(json.decode(response.body), jwt);
      default:
        return null;
    }
  }

  Future<UserModel?> fetchUserProfile({
    required String jwt,
  }) async {
    try {
      Map<String, String> bearerHeaders = {
        'Content-Type': 'application/json-patch+json',
        'Authorization': 'Bearer ${jwt}',};

      final response = await http.get(
        Uri.parse(APIPathConstant.API_SERVER_PATH + '/api/students/information'),
        headers: bearerHeaders,
      );
      switch (response.statusCode) {
        case 200:
          return getAccount(json.decode(response.body), jwt);
        case 201:
          return getAccount(json.decode(response.body), jwt);
        default:
          return null;
      }
    } catch (e) {}
  }

  static UserModel getAccount(Map<String, dynamic> jsonData, String accessToken) {
    UserModel userModel = UserModel.fromJson(jsonData, accessToken);
    return userModel;
  }
}
