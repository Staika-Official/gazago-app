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
  int? time;
  String? startedDate;
  String? endedDate;
  double? rewardGo;
  String? state;
  int? badgeIssueId;
  int? challengeId;
  String? badgeDescription;
  String? challengeName;
  double? spendDurability;
  double? spendStamina;

  ArchiveListItemModel({
    this.id,
    this.userId,
    this.type,
    this.steps,
    this.speed,
    this.distance,
    this.altitude,
    this.time,
    this.startedDate,
    this.endedDate,
    this.rewardGo,
    this.state,
    this.badgeIssueId,
    this.challengeId,
    this.badgeDescription,
    this.challengeName,
    this.spendDurability,
    this.spendStamina,
  });

  factory ArchiveListItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveListItemModelToJson(this);
}
