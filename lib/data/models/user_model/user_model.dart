import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: false)
class UserModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;
  String? classStatus;
  final String college;
  final String? phone;
  final String? address;
  final String? dayOfBirth;
  final String status;
  String? accessToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
    this.classStatus,
    required this.college,
    this.phone,
    this.address,
    this.dayOfBirth,
    required this.status,
    this.accessToken,
  });

  UserModel copyWith({
    User? firebaseUser,
    String? address,
    String? birthDate,
    String? email,
    String? grade,
    String? name,
    String? phoneNumber,
    String? school,
    String? accessToken,
    String? avatarUrl,
    String? classStatus,
    String? phone,
    String? dayOfBirth,
    String? status,
  }) {
    return UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      classStatus: classStatus ?? this.classStatus,
      college: college,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dayOfBirth: dayOfBirth ?? this.dayOfBirth,
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  List<Object?> get props => [];

  factory UserModel.fromJson(Map<String, dynamic> json, String accessToken) =>
      _$UserModelFromJson(json, accessToken);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
