import 'package:gaza_go/platform/models/challenge_notification_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_notification_group_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeNotificationGroupModel {
  int id;
  List<ChallengeNotificationItemModel> challengeNotifications;

  ChallengeNotificationGroupModel({
    required this.id,
    required this.challengeNotifications,
  });

  factory ChallengeNotificationGroupModel.fromJson(Map<String, dynamic> json) => _$ChallengeNotificationGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeNotificationGroupModelToJson(this);
}
