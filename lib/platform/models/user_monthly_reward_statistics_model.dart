import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_monthly_reward_statistics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserMonthlyRewardStatisticsModel {
  double totalTik;
  double totalStik;
  List<UserRewardStatisticsModel>? rewards;

  UserMonthlyRewardStatisticsModel({
    required this.totalTik,
    required this.totalStik,
    this.rewards,
  });

  factory UserMonthlyRewardStatisticsModel.fromJson(Map<String, dynamic> json) => _$UserMonthlyRewardStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserMonthlyRewardStatisticsModelToJson(this);
}
