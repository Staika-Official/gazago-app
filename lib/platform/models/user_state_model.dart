import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_state_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class UserStateModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  int userId;
  @HiveField(2)
  double? stamina;
  @HiveField(3)
  String? badgeCoolDown;
  @HiveField(4)
  double? dailyGoReward;
  @HiveField(5)
  String? createdBy;
  @HiveField(6)
  String? createdDate;
  @HiveField(7)
  String? lastModifiedBy;
  @HiveField(8)
  String? lastModifiedDate;
  @HiveField(9)
  bool? locked;

  UserStateModel({
    required this.id,
    required this.userId,
    this.stamina,
    this.dailyGoReward,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.locked,
  });

  factory UserStateModel.fromJson(Map<String, dynamic> json) => _$UserStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateModelToJson(this);
}
