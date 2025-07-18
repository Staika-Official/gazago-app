import 'package:json_annotation/json_annotation.dart';

part 'challenge_notification_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeNotificationItemModel {
  int id;
  String imageUrl;
  String message;
  int listOrder;

  ChallengeNotificationItemModel({
    required this.id,
    required this.imageUrl,
    required this.message,
    required this.listOrder,
  });

  factory ChallengeNotificationItemModel.fromJson(Map<String, dynamic> json) => _$ChallengeNotificationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeNotificationItemModelToJson(this);
}
