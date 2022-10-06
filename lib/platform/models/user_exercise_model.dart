import 'package:json_annotation/json_annotation.dart';

part 'user_exercise_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserExerciseModel {
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
  String? state;
  bool? deleted;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  //운동 시작할때만 필요한 파라미터
  String? type;
  String? userProfileImageUrl;
  String? userNickname;
  int? challengeId;

  UserExerciseModel({
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
    this.state,
    this.deleted,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.type,
    this.userProfileImageUrl,
    this.userNickname,
    this.challengeId,
  });

  factory UserExerciseModel.fromJson(Map<String, dynamic> json) => _$UserExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserExerciseModelToJson(this);
}
