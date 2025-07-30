// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_crew_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyCrewItemModel _$CompanyCrewItemModelFromJson(
        Map<String, dynamic> json) =>
    CompanyCrewItemModel(
      crewId: (json['crewId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      rewardDistance: (json['rewardDistance'] as num).toInt(),
      crewName: json['crewName'] as String,
      nickname: json['nickname'] as String,
      crewIconImageUrl: json['crewIconImageUrl'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      listFixed: json['listFixed'] as bool,
    );

Map<String, dynamic> _$CompanyCrewItemModelToJson(
        CompanyCrewItemModel instance) =>
    <String, dynamic>{
      'crewId': instance.crewId,
      'userId': instance.userId,
      'rewardDistance': instance.rewardDistance,
      'crewName': instance.crewName,
      'nickname': instance.nickname,
      'crewIconImageUrl': instance.crewIconImageUrl,
      'profileImageUrl': instance.profileImageUrl,
      'listFixed': instance.listFixed,
    };
