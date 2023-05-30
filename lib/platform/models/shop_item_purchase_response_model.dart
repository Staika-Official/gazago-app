import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_item_purchase_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemPurchaseResponseModel {
  int id;
  int userId;
  int? nftId;
  String serialNumber;
  String itemName;
  String itemImageUrl;
  String? publishType;
  String itemCategory;
  String itemGrade;
  double durability;
  double? abrasionRate;
  double? rewardRate;
  double? staminaReduceRate;
  String? description;

  InventoryItemStatModel? itemStat;
  bool? equippedChallengeItem;
  bool? challengeItem;

  ShopItemPurchaseResponseModel({
    required this.id,
    required this.userId,
    this.nftId,
    required this.serialNumber,
    required this.itemName,
    required this.itemImageUrl,
    this.publishType,
    required this.itemCategory,
    required this.itemGrade,
    required this.durability,
    this.abrasionRate,
    this.rewardRate,
    this.staminaReduceRate,
    this.description,
    this.itemStat,
    this.equippedChallengeItem,
    this.challengeItem,
  });

  factory ShopItemPurchaseResponseModel.fromJson(Map<String, dynamic> json) => _$ShopItemPurchaseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemPurchaseResponseModelToJson(this);
}
