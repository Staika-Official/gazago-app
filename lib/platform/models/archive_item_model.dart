import 'package:gaza_go/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'archive_item_model.g.dart';

@JsonSerializable()
class ArchiveItemModel {
  int? id;
  int? userId;
  int? steps;
  double? speed;
  double? distance;
  double? altitude;
  int? time;
  String? startPoint;
  double? rewardGo;
  double? rewardDistance;
  double? spendStamina;
  double? spendDurability;
  String? startedDate;
  String? endedDate;
  String? locations;
  int? badgeIssueId;
  int? challengeId;
  String? state;
  bool? deleted;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

  ArchiveItemModel({
    this.id,
    this.userId,
    this.steps,
    this.speed,
    this.distance,
    this.altitude,
    this.time,
    this.startPoint,
    this.rewardGo,
    this.rewardDistance,
    this.spendStamina,
    this.spendDurability,
    this.startedDate,
    this.endedDate,
    this.locations,
    this.badgeIssueId,
    this.challengeId,
    this.state,
    this.deleted,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory ArchiveItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveItemModelToJson(this);
}
