import 'package:json_annotation/json_annotation.dart';

part 'user_shoes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserShoesModel {
  int? id;
  int? userId;
  String? serialNumber;
  String? itemName;
  String? itemCategory;
  double? durability;
  double? abrasionRate;
  double? rewardRate;
  double? staminaReduceRate;
  String? itemImageUrl;
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
