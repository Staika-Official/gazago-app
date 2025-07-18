// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_notification_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeNotificationGroupModel _$ChallengeNotificationGroupModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeNotificationGroupModel(
      id: (json['id'] as num).toInt(),
      challengeNotifications: (json['challengeNotifications'] as List<dynamic>)
          .map((e) => ChallengeNotificationItemModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengeNotificationGroupModelToJson(
        ChallengeNotificationGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeNotifications':
          instance.challengeNotifications.map((e) => e.toJson()).toList(),
    };
