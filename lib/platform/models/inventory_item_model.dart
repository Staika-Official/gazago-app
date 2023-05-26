import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryItemModel {
  int id;
  int? userId;
  int? nftId;
  String serialNumber;
  String itemName;
  String? publishType;
  String itemCategory;
  String itemGrade;
  double durability;
  double? abrasionRate;
  double? rewardRate;
  double? staminaReduceRate;
  String itemImageUrl;
  String? description;
  bool? equipped;
  int? listOrder;
  int? tik;
  bool? isShoe;
  InventoryItemStatModel? itemStat;
  bool? equippedChallengeItem;
  bool? challengeItem;

  InventoryItemModel({
    required this.id,
    this.userId,
    this.nftId,
    required this.serialNumber,
    required this.itemGrade,
    required this.itemName,
    this.publishType,
    required this.itemCategory,
    required this.durability,
    this.abrasionRate,
    this.rewardRate,
    this.staminaReduceRate,
    required this.itemImageUrl,
    this.itemStat,
    this.description,
    this.equipped,
    this.listOrder,
    this.tik = 0,
    this.isShoe = false,
    this.equippedChallengeItem,
    this.challengeItem
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
