import 'package:json_annotation/json_annotation.dart';

part 'user_exercise_model.g.dart';

@JsonSerializable()
class UserExerciseModel {
  int id;
  int userId;
  int steps;
  int speed;
  int distance;
  int altitude;
  int time;
  String startPoint;
  double rewardGo;
  int rewardDistance;
  double spendStamina;
  double spendDurability;
  String startedDate;
  String endedDate;
  String locations;
  String badgeIssueId;
  String state;
  bool deleted;
  String createdBy;
  String createdDate;
  String lastModifiedBy;
  String lastModifiedDate;

  UserExerciseModel({
    required this.id,
    required this.userId,
    required this.steps,
    required this.speed,
    required this.distance,
    required this.altitude,
    required this.time,
    required this.startPoint,
    required this.rewardGo,
    required this.rewardDistance,
    required this.spendStamina,
    required this.spendDurability,
    required this.startedDate,
    required this.endedDate,
    required this.locations,
    required this.badgeIssueId,
    required this.state,
    required this.deleted,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
  });

  factory UserExerciseModel.fromJson(Map<String, dynamic> json) => _$UserExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserExerciseModelToJson(this);
}
