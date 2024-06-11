import 'package:json_annotation/json_annotation.dart';

part 'gathering_reward_badge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GatheringRewardBadgeModel {
  int id;
  String name;
  String imageUrl;
  String? description;
  double? luckRateFrom;
  double? luckRateTo;
  double? rewardRateFrom;
  double? rewardRateTo;

  GatheringRewardBadgeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.luckRateFrom,
    this.luckRateTo,
    this.rewardRateFrom,
    this.rewardRateTo,
  });

  factory GatheringRewardBadgeModel.fromJson(Map<String, dynamic> json) => _$GatheringRewardBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$GatheringRewardBadgeModelToJson(this);
}
