import 'package:json_annotation/json_annotation.dart';

part 'user_state_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserStateModel {
  int id;
  int userId;
  double? stamina;
  String? badgeCoolDown;
  double? dailyGoReward;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

  UserStateModel({
    required this.id,
    required this.userId,
    this.stamina,
    this.dailyGoReward,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory UserStateModel.fromJson(Map<String, dynamic> json) => _$UserStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateModelToJson(this);
}
