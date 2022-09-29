import 'package:json_annotation/json_annotation.dart';

part 'archive_item_model.g.dart';

@JsonSerializable()
class ArchiveItemModel {
  int? id;
  int? userId;
  String? type;
  int? steps;
  double? speed;
  double? distance;
  int? time;
  String? startedDate;
  String? endedDate;
  double? rewardGo;
  String? state;
  int? badgeIssueId;
  int? challengeId;
  String? badgeDescription;
  String? challengeName;

  ArchiveItemModel({
    this.id,
    this.userId,
    this.type,
    this.steps,
    this.speed,
    this.distance,
    this.time,
    this.startedDate,
    this.endedDate,
    this.rewardGo,
    this.state,
    this.badgeIssueId,
    this.challengeId,
    this.badgeDescription,
    this.challengeName,
  });

  factory ArchiveItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveItemModelToJson(this);
}
