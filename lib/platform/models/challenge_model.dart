import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeModel {
  int? id;
  String? type;
  String? title;
  String? firstName;
  String? secondName;
  double? startLat;
  double? startLon;
  double? startRadius;
  double? endLat;
  double? endLon;
  double? endRadius;
  String? difficulty;
  double? difficultyRate;
  double? distance;
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
    this.startLat,
    this.startLon,
    this.startRadius,
    this.endLat,
    this.endLon,
    this.endRadius,
    this.difficulty,
    this.difficultyRate,
    this.distance,
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
