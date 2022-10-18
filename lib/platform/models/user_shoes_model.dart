import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_shoes_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(explicitToJson: true)
class UserShoesModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? userId;
  @HiveField(2)
  String? serialNumber;
  @HiveField(3)
  String? itemName;
  @HiveField(4)
  String? itemCategory;
  @HiveField(5)
  double? durability;
  @HiveField(6)
  double? abrasionRate;
  @HiveField(7)
  double? rewardRate;
  @HiveField(8)
  double? staminaReduceRate;
  @HiveField(9)
  String? itemImageUrl;
  @HiveField(10)
  String? description;

  UserShoesModel({
    this.id,
    this.userId,
    this.serialNumber,
    this.itemName,
    this.itemCategory,
    this.durability,
    this.abrasionRate,
    this.rewardRate,
    this.staminaReduceRate,
    this.itemImageUrl,
    this.description,
  });

  factory UserShoesModel.fromJson(Map<String, dynamic> json) => _$UserShoesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserShoesModelToJson(this);
}
