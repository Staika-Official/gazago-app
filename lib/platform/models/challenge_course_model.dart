import 'package:gaza_go/platform/models/checkpoint_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_course_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeCourseModel {
  int? id;
  int? challengeId;
  String? type;
  String? title;
  String? firstName;
  String? secondName;
  String? startPointName;
  double? startLat;
  double? startLon;
  double? startRadius;
  String? endPointName;
  double? endLat;
  double? endLon;
  double? endRadius;
  String? difficulty;
  double? difficultyRate;
  double? altitude;
  double? distance;
  double? travelTime;
  String? province;
  String? rewardImageUrl;
  bool? activated;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  List<CheckpointModel>? checkpoints;

  ChallengeCourseModel({
    this.id,
    this.challengeId,
    this.type,
    this.title,
    this.firstName,
    this.secondName,
    this.startPointName,
    this.startLat,
    this.startLon,
    this.startRadius,
    this.endPointName,
    this.endLat,
    this.endLon,
    this.endRadius,
    this.difficulty,
    this.difficultyRate,
    this.altitude,
    this.distance,
    this.travelTime,
    this.province,
    this.rewardImageUrl,
    this.activated,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory ChallengeCourseModel.fromJson(Map<String, dynamic> json) => _$ChallengeCourseModelFromJson(json);

  Object? get length => null;

  Map<String, dynamic> toJson() => _$ChallengeCourseModelToJson(this);
}
