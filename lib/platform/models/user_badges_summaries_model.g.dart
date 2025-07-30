// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_badges_summaries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBadgesSummariesModel _$UserBadgesSummariesModelFromJson(
        Map<String, dynamic> json) =>
    UserBadgesSummariesModel(
      id: (json['id'] as num).toInt(),
      state: json['state'] as String,
      badgeComposeConfigId: (json['badgeComposeConfigId'] as num).toInt(),
    );

Map<String, dynamic> _$UserBadgesSummariesModelToJson(
        UserBadgesSummariesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'badgeComposeConfigId': instance.badgeComposeConfigId,
    };
