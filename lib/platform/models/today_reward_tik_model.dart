import 'package:json_annotation/json_annotation.dart';

part 'today_reward_tik_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TodayRewardTikModel {
  String? aggregatedDate;
  double? rewardTik;

  TodayRewardTikModel({
    this.aggregatedDate,
    this.rewardTik,
  });

  factory TodayRewardTikModel.fromJson(Map<String, dynamic> json) => _$TodayRewardTikModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayRewardTikModelToJson(this);
}
