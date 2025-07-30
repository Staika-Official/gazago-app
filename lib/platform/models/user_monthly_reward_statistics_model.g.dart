// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_monthly_reward_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMonthlyRewardStatisticsModel _$UserMonthlyRewardStatisticsModelFromJson(
        Map<String, dynamic> json) =>
    UserMonthlyRewardStatisticsModel(
      totalTik: (json['totalTik'] as num).toDouble(),
      totalStik: (json['totalStik'] as num).toDouble(),
      rewards: (json['rewards'] as List<dynamic>?)
          ?.map((e) =>
              UserRewardStatisticsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserMonthlyRewardStatisticsModelToJson(
        UserMonthlyRewardStatisticsModel instance) =>
    <String, dynamic>{
      'totalTik': instance.totalTik,
      'totalStik': instance.totalStik,
      'rewards': instance.rewards?.map((e) => e.toJson()).toList(),
    };
