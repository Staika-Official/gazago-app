// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering_reward_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatheringRewardBadgeModel _$GatheringRewardBadgeModelFromJson(
        Map<String, dynamic> json) =>
    GatheringRewardBadgeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      luckRateFrom: (json['luckRateFrom'] as num?)?.toDouble(),
      luckRateTo: (json['luckRateTo'] as num?)?.toDouble(),
      rewardRateFrom: (json['rewardRateFrom'] as num?)?.toDouble(),
      rewardRateTo: (json['rewardRateTo'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GatheringRewardBadgeModelToJson(
        GatheringRewardBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'luckRateFrom': instance.luckRateFrom,
      'luckRateTo': instance.luckRateTo,
      'rewardRateFrom': instance.rewardRateFrom,
      'rewardRateTo': instance.rewardRateTo,
    };
