// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      walletAddress: json['walletAddress'] as String,
      socialAccounts: json['socialAccounts'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      age: (json['age'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'walletAddress': instance.walletAddress,
      'socialAccounts': instance.socialAccounts,
      'email': instance.email,
      'gender': instance.gender,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
    };
