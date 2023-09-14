import 'package:json_annotation/json_annotation.dart';

part 'archive_list_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ArchiveListItemModel {
  int? id;
  int? userId;
  String? type;
  int? steps;
  double? speed;
  double? distance;
  double? altitude;
  double? maxAltitude;
  int? time;
  String? startedDate;
  String? endedDate;
  double? rewardGo;
  double? rewardDistance;
  double? spendDurability;
  double? spendStamina;
  String? state;
  int? badgeIssueId;
  int? challengeId;
  int? challengeCourseId;
  String? challengeActivationType;
  String? badgeName;
  String? badgeImageUrl;
  String? challengeTitle;
  double? degreeRewardGo;
  double? degreeSpendDurability;
  double? degreeSpendStamina;
  int? luckOccurredCount;
  double? luckApplyRewardGo;

  ArchiveListItemModel({
    this.id,
    this.userId,
    this.type,
    this.steps,
    this.speed,
    this.distance,
    this.altitude,
    this.maxAltitude,
    this.time,
    this.startedDate,
    this.endedDate,
    this.rewardGo,
    this.rewardDistance,
    this.spendDurability,
    this.spendStamina,
    this.state,
    this.badgeIssueId,
    this.challengeId,
    this.challengeCourseId,
    this.challengeActivationType,
    this.badgeName,
    this.badgeImageUrl,
    this.challengeTitle,
    this.degreeRewardGo,
    this.degreeSpendDurability,
    this.degreeSpendStamina,
    this.luckOccurredCount,
    this.luckApplyRewardGo,
  });

  factory ArchiveListItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveListItemModelToJson(this);
}
