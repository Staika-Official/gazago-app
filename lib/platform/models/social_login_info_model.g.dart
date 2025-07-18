// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginInfoModel _$SocialLoginInfoModelFromJson(
        Map<String, dynamic> json) =>
    SocialLoginInfoModel(
      provider: json['provider'] as String,
      deviceId: json['deviceId'] as String,
      fcmToken: json['fcmToken'] as String,
      token: json['token'] as String,
      appVersion: json['appVersion'] as String,
      deviceModel: json['deviceModel'] as String,
      osVersion: json['osVersion'] as String,
      platform: json['platform'] as String,
      clientId: json['clientId'] as String,
      forceLogin: json['forceLogin'] as bool,
      providerEnv: json['providerEnv'] as String?,
      inviteUserId: json['inviteUserId'] as String?,
    );

Map<String, dynamic> _$SocialLoginInfoModelToJson(
        SocialLoginInfoModel instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
      'token': instance.token,
      'appVersion': instance.appVersion,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
      'platform': instance.platform,
      'clientId': instance.clientId,
      'forceLogin': instance.forceLogin,
      'providerEnv': instance.providerEnv,
      'inviteUserId': instance.inviteUserId,
    };
