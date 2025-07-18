import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'inventory_item_stat_model.dart';

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
  @HiveField(11)
  int? nftId;
  @HiveField(12)
  int? itemId;
  @HiveField(13)
  String? expiredDate;
  @HiveField(14)
  InventoryItemStatModel? itemStat;

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
    this.nftId,
    this.itemId,
    this.expiredDate,
    this.itemStat,
  });

  factory UserShoesModel.fromJson(Map<String, dynamic> json) => _$UserShoesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserShoesModelToJson(this);
}
