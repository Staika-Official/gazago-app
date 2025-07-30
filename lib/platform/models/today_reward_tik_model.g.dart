// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_reward_tik_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayRewardTikModel _$TodayRewardTikModelFromJson(Map<String, dynamic> json) =>
    TodayRewardTikModel(
      aggregatedDate: json['aggregatedDate'] as String?,
      rewardTik: (json['rewardTik'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TodayRewardTikModelToJson(
        TodayRewardTikModel instance) =>
    <String, dynamic>{
      'aggregatedDate': instance.aggregatedDate,
      'rewardTik': instance.rewardTik,
    };
