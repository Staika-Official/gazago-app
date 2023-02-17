import 'package:json_annotation/json_annotation.dart';

part 'user_reward_statistics_model.g.dart';

//TODO. 삭제 / DailyRewardModel 와 통합
@JsonSerializable(explicitToJson: true)
class UserRewardStatisticsModel {
  double go;
  double tik;
  String? date;

  UserRewardStatisticsModel({
    required this.go,
    required this.tik,
    this.date,
  });

  factory UserRewardStatisticsModel.fromJson(Map<String, dynamic> json) => _$UserRewardStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRewardStatisticsModelToJson(this);
}
