import 'package:json_annotation/json_annotation.dart';

part 'user_exercise_model.g.dart';

@JsonSerializable()
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
  String? badgeIssueId;
  String? state;
  bool? deleted;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

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
  });

  factory UserExerciseModel.fromJson(Map<String, dynamic> json) => _$UserExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserExerciseModelToJson(this);
}
