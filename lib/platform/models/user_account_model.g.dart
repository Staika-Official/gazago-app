// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    UserAccountModel(
      id: (json['id'] as num).toInt(),
      login: json['login'] as String?,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      availableChangeNickname: json['availableChangeNickname'] as bool?,
      profileImageUrl: json['profileImageUrl'] as String?,
      phone: json['phone'] as String?,
      userCode: json['userCode'] as String?,
      provider: json['provider'] as String?,
      marketingChecked: json['marketingChecked'] as bool?,
      alarmTransaction: json['alarmTransaction'] as bool?,
      alarmEvent: json['alarmEvent'] as bool?,
      activated: json['activated'] as bool?,
      createdDate: json['createdDate'] as String?,
      authorities: (json['authorities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      terminationDate: json['terminationDate'] as String?,
    );

Map<String, dynamic> _$UserAccountModelToJson(UserAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'login': instance.login,
      'email': instance.email,
      'nickname': instance.nickname,
      'availableChangeNickname': instance.availableChangeNickname,
      'profileImageUrl': instance.profileImageUrl,
      'phone': instance.phone,
      'userCode': instance.userCode,
      'provider': instance.provider,
      'marketingChecked': instance.marketingChecked,
      'alarmTransaction': instance.alarmTransaction,
      'alarmEvent': instance.alarmEvent,
      'activated': instance.activated,
      'createdDate': instance.createdDate,
      'authorities': instance.authorities,
      'terminationDate': instance.terminationDate,
    };
