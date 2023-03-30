import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_exercise_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class UserExerciseModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? userId;
  @HiveField(2)
  int? steps;
  @HiveField(3)
  double? speed;
  @HiveField(4)
  double? distance;
  @HiveField(5)
  double? altitude;
  @HiveField(6)
  int? time;
  @HiveField(7)
  String? startPoint;
  @HiveField(8)
  num? rewardGo;
  @HiveField(9)
  double? rewardDistance;
  @HiveField(10)
  double? spendStamina;
  @HiveField(11)
  double? spendDurability;
  @HiveField(12)
  String? startedDate;
  @HiveField(13)
  String? endedDate;
  @HiveField(14)
  String? locations;
  @HiveField(15)
  int? badgeIssueId;
  @HiveField(16)
  String? state;
  @HiveField(17)
  bool? deleted;
  @HiveField(18)
  String? createdBy;
  @HiveField(19)
  String? createdDate;
  @HiveField(20)
  String? lastModifiedBy;
  @HiveField(21)
  String? lastModifiedDate;
  //운동 시작할때만 필요한 파라미터
  @HiveField(22)
  String? type;
  @HiveField(23)
  String? userProfileImageUrl;
  @HiveField(24)
  String? userNickname;
  @HiveField(25)
  int? challengeId;
  @HiveField(26)
  DateTime? locationUpdateTime;
  @HiveField(27)
  String? recordState;
  @HiveField(28)
  String? adId;
  @HiveField(29)
  double? lastLatitude;
  @HiveField(30)
  double? lastLongitude;

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
    this.locationUpdateTime,
    this.recordState,
    this.adId,
    this.lastLatitude,
    this.lastLongitude,
  });

  factory UserExerciseModel.fromJson(Map<String, dynamic> json) => _$UserExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserExerciseModelToJson(this);
}
