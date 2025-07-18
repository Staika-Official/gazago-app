import 'package:json_annotation/json_annotation.dart';

part 'challenge_ranker_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeRankerModel {
  int? id;
  int? userId;
  int? rank;
  String? profileImageUrl;
  String? nickname;
  double rewardGo;
  double rewardTik;
  double? additionTik;
  double? additionStik;
  int rewardDistance;

  ChallengeRankerModel({
    this.id,
    this.userId,
    this.rank,
    required this.profileImageUrl,
    this.nickname,
    required this.rewardGo,
    required this.rewardTik,
    this.additionTik,
    this.additionStik,
    required this.rewardDistance,
  });

  factory ChallengeRankerModel.fromJson(Map<String, dynamic> json) => _$ChallengeRankerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeRankerModelToJson(this);
}
