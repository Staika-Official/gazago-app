import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class ChallengeModel {
  int id;
  String type;
  String title;
  String firstName;
  String secondName;
  double startLat;
  double startLon;
  double startRadius;
  double endLat;
  double endLon;
  double endRadius;
  String difficulty;
  double difficultyRate;
  double distance;
  String province;
  String rewardImageUrl;
  bool activated;
  String createdBy;
  String createdDate;
  String lastModifiedBy;
  String lastModifiedDate;

  ChallengeModel({
    required this.id,
    required this.type,
    required this.title,
    required this.firstName,
    required this.secondName,
    required this.startLat,
    required this.startLon,
    required this.startRadius,
    required this.endLat,
    required this.endLon,
    required this.endRadius,
    required this.difficulty,
    required this.difficultyRate,
    required this.distance,
    required this.province,
    required this.rewardImageUrl,
    required this.activated,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);
}
