import 'package:json_annotation/json_annotation.dart';

part 'push_message_challenge_success_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PushMessageChallengeSuccessModel {
  String? notificationKey;
  String? clientId;
  String? title;
  String? body;
  String? badgeImageUrl;
  String? challengeTitle;

  PushMessageChallengeSuccessModel({
    this.notificationKey,
    this.clientId,
    this.title,
    this.body,
    this.badgeImageUrl,
    this.challengeTitle,
  });

  factory PushMessageChallengeSuccessModel.fromJson(Map<String, dynamic> json) => _$PushMessageChallengeSuccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$PushMessageChallengeSuccessModelToJson(this);
}
