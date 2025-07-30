// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenModel _$AccessTokenModelFromJson(Map<String, dynamic> json) =>
    AccessTokenModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accountStatus: json['accountStatus'] as String?,
    );

Map<String, dynamic> _$AccessTokenModelToJson(AccessTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accountStatus': instance.accountStatus,
    };
