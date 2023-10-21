// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json, String accessToken) => UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      college: json['college'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dayOfBirth: json['dayOfBirth'] ?? '',
      status: json['status'] ?? '',
      accessToken: accessToken,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'college': instance.college,
      'phone': instance.phone,
      'address': instance.address,
      'dayOfBirth': instance.dayOfBirth,
      'status': instance.status,
      'accessToken': instance.accessToken,
};
