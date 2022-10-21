import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeModel {
  int? id;
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

  ChallengeModel({
    this.id,
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

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);
}
