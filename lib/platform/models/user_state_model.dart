import 'package:json_annotation/json_annotation.dart';

part 'user_state_model.g.dart';

@JsonSerializable()
class UserStateModel {
  int id;
  int userId;
  double stamina;
  double dailyGoReward;
  String createdBy;
  String createdDate;
  String lastModifiedBy;
  String lastModifiedDate;

  UserStateModel({
    required this.id,
    required this.userId,
    required this.stamina,
    required this.dailyGoReward,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
  });

  factory UserStateModel.fromJson(Map<String, dynamic> json) => _$UserStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateModelToJson(this);
}
