// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeRewardModel _$ChallengeRewardModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeRewardModel(
      rewardTik: (json['rewardTik'] as num?)?.toDouble(),
      additionTik: json['additionTik'] as String?,
      additionStik: json['additionStik'] as String?,
    );

Map<String, dynamic> _$ChallengeRewardModelToJson(
        ChallengeRewardModel instance) =>
    <String, dynamic>{
      'rewardTik': instance.rewardTik,
      'additionTik': instance.additionTik,
      'additionStik': instance.additionStik,
    };
