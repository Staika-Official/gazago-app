// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_notification_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeNotificationItemModel _$ChallengeNotificationItemModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeNotificationItemModel(
      id: (json['id'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      message: json['message'] as String,
      listOrder: (json['listOrder'] as num).toInt(),
    );

Map<String, dynamic> _$ChallengeNotificationItemModelToJson(
        ChallengeNotificationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'message': instance.message,
      'listOrder': instance.listOrder,
    };
