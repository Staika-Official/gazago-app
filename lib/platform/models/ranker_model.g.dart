// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankerModel _$RankerModelFromJson(Map<String, dynamic> json) => RankerModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      rank: (json['rank'] as num?)?.toInt(),
      profileImageUrl: json['profileImageUrl'] as String?,
      nickname: json['nickname'] as String,
      rewardGo: (json['rewardGo'] as num).toDouble(),
      rewardTik: (json['rewardTik'] as num).toDouble(),
      aggregatedDate: json['aggregatedDate'] as String,
      additionTik: (json['additionTik'] as num?)?.toDouble(),
      additionStik: (json['additionStik'] as num?)?.toDouble(),
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
      userKeyword: json['userKeyword'] as String,
    );

Map<String, dynamic> _$RankerModelToJson(RankerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'rank': instance.rank,
      'profileImageUrl': instance.profileImageUrl,
      'nickname': instance.nickname,
      'rewardGo': instance.rewardGo,
      'rewardTik': instance.rewardTik,
      'additionTik': instance.additionTik,
      'additionStik': instance.additionStik,
      'aggregatedDate': instance.aggregatedDate,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'userKeyword': instance.userKeyword,
    };
