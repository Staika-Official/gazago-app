import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeModel {
  int id;
  String challengeType;
  String simpleTitle;
  String subTitle;
  String fromDate;
  String toDate;
  String thumbnailImageUrl;

  ChallengeModel({
    required this.id,
    required this.challengeType,
    required this.simpleTitle,
    required this.subTitle,
    required this.fromDate,
    required this.toDate,
    required this.thumbnailImageUrl,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);
}
