import 'package:json_annotation/json_annotation.dart';

part 'challenge_reward_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeRewardModel {
  double? rewardTik;
  String? additionTik;
  String? additionStik;

  ChallengeRewardModel({
    this.rewardTik,
    this.additionTik,
    this.additionStik,
  });

  factory ChallengeRewardModel.fromJson(Map<String, dynamic> json) => _$ChallengeRewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeRewardModelToJson(this);
}
