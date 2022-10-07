import 'package:json_annotation/json_annotation.dart';

part 'archive_detail_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ArchiveDetailItemModel {
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
  String? badgeName;
  String? challengeTitle;
  String? locations;
  double? spendDurability;
  double? spendStamina;

  ArchiveDetailItemModel({
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
    this.badgeName,
    this.challengeTitle,
    this.locations,
    this.spendDurability,
    this.spendStamina,
  });

  factory ArchiveDetailItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveDetailItemModelToJson(this);
}
