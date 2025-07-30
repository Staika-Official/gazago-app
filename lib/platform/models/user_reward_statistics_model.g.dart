// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reward_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRewardStatisticsModel _$UserRewardStatisticsModelFromJson(
        Map<String, dynamic> json) =>
    UserRewardStatisticsModel(
      stik: (json['stik'] as num?)?.toDouble(),
      tik: (json['tik'] as num?)?.toDouble(),
      date: json['date'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserRewardStatisticsModelToJson(
        UserRewardStatisticsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stik': instance.stik,
      'tik': instance.tik,
      'date': instance.date,
    };
