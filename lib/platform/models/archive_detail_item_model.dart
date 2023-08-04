import 'package:gaza_go/platform/models/challenge_course_model.dart';
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
  int? challengeCourseId;
  String? challengeActivationType;
  String? badgeName;
  String? badgeImageUrl;
  double? spendDurability;
  double? spendStamina;
  String? title;
  String? firstName;
  String? secondName;
  String? startPointName;
  String? endPointName;
  String? description;
  String? province;
  double? rewardGoExerciseSum;
  double? rewardGoAdSum;
  double? luckApplyTotalRewardGo;
  int? luckOccurredCount;
  String? locationsStr;
  ChallengeCourseModel? challengeCourse;

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
    this.challengeCourseId,
    this.challengeActivationType,
    this.badgeName,
    this.badgeImageUrl,
    this.spendDurability,
    this.spendStamina,
    this.title,
    this.firstName,
    this.secondName,
    this.startPointName,
    this.endPointName,
    this.description,
    this.province,
    this.rewardGoExerciseSum,
    this.rewardGoAdSum,
    this.luckApplyTotalRewardGo,
    this.luckOccurredCount,
    this.locationsStr,
    this.challengeCourse,
  });

  factory ArchiveDetailItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveDetailItemModelToJson(this);
}
