import 'package:json_annotation/json_annotation.dart';

part 'daily_reward_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyRewardModel {
  int? id;
  DateTime? rewardedDate;
  double? stikAmount;
  int? tikAmount;

  DailyRewardModel({
    this.id,
    this.rewardedDate,
    this.stikAmount,
    this.tikAmount,
  });

  factory DailyRewardModel.fromJson(Map<String, dynamic> json) => _$DailyRewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyRewardModelToJson(this);
}
