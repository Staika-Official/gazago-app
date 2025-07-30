// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_ranker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeRankerModel _$ChallengeRankerModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeRankerModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      rank: (json['rank'] as num?)?.toInt(),
      profileImageUrl: json['profileImageUrl'] as String?,
      nickname: json['nickname'] as String?,
      rewardGo: (json['rewardGo'] as num).toDouble(),
      rewardTik: (json['rewardTik'] as num).toDouble(),
      additionTik: (json['additionTik'] as num?)?.toDouble(),
      additionStik: (json['additionStik'] as num?)?.toDouble(),
      rewardDistance: (json['rewardDistance'] as num).toInt(),
    );

Map<String, dynamic> _$ChallengeRankerModelToJson(
        ChallengeRankerModel instance) =>
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
      'rewardDistance': instance.rewardDistance,
    };
