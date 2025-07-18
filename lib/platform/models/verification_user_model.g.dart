// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationUserModel _$VerificationUserModelFromJson(
        Map<String, dynamic> json) =>
    VerificationUserModel(
      name: json['name'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      mobileCompany: json['mobileCompany'] as String? ?? '',
      isForeigner: json['isForeigner'] as bool? ?? true,
      clientId: json['clientId'] as String? ?? '',
    );

Map<String, dynamic> _$VerificationUserModelToJson(
        VerificationUserModel instance) =>
    <String, dynamic>{
      'birthday': instance.birthday,
      'gender': instance.gender,
      'name': instance.name,
      'mobileCompany': instance.mobileCompany,
      'mobileNumber': instance.mobileNumber,
      'isForeigner': instance.isForeigner,
      'clientId': instance.clientId,
    };
