import 'package:json_annotation/json_annotation.dart';

part 'user_reward_statistics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRewardStatisticsModel {
  int? id;
  double? stik;
  double? tik;
  String? date;

  UserRewardStatisticsModel({
    this.stik,
    this.tik,
    this.date,
    this.id,
  });

  factory UserRewardStatisticsModel.fromJson(Map<String, dynamic> json) => _$UserRewardStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRewardStatisticsModelToJson(this);
}
