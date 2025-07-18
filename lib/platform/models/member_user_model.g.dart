// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberUserModel _$MemberUserModelFromJson(Map<String, dynamic> json) =>
    MemberUserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      availableChangeNickname: json['availableChangeNickname'] as bool?,
      userCode: json['userCode'] as String?,
      countryCode: json['countryCode'] as String?,
      marketingChecked: json['marketingChecked'] as bool?,
      alarmTransaction: json['alarmTransaction'] as bool?,
      alarmEvent: json['alarmEvent'] as bool?,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$MemberUserModelToJson(MemberUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'userCode': instance.userCode,
      'countryCode': instance.countryCode,
      'marketingChecked': instance.marketingChecked,
      'availableChangeNickname': instance.availableChangeNickname,
      'alarmEvent': instance.alarmEvent,
      'alarmTransaction': instance.alarmTransaction,
      'provider': instance.provider,
    };
