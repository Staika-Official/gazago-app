// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_message_challenge_success_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushMessageChallengeSuccessModel _$PushMessageChallengeSuccessModelFromJson(
        Map<String, dynamic> json) =>
    PushMessageChallengeSuccessModel(
      notificationKey: json['notificationKey'] as String?,
      clientId: json['clientId'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      badgeImageUrl: json['badgeImageUrl'] as String?,
      challengeTitle: json['challengeTitle'] as String?,
    );

Map<String, dynamic> _$PushMessageChallengeSuccessModelToJson(
        PushMessageChallengeSuccessModel instance) =>
    <String, dynamic>{
      'notificationKey': instance.notificationKey,
      'clientId': instance.clientId,
      'title': instance.title,
      'body': instance.body,
      'badgeImageUrl': instance.badgeImageUrl,
      'challengeTitle': instance.challengeTitle,
    };
