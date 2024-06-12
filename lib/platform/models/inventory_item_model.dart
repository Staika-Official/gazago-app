import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/shop_item_challenge_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryItemModel {
  int id;
  int? userId;
  int? itemId;
  int? nftId;
  String? serialNumber;
  String itemName;
  String? publishType;
  String? itemPublishType;
  String itemCategory;
  String itemGrade;
  String? itemType;
  String? expiredDate;
  double? durability;
  double? abrasionRate;
  double? rewardRate;
  double? staminaReduceRate;
  String itemImageUrl;
  String? description;
  String? tokenAddress;
  String? nftTokenAddress;
  bool? equipped;
  bool? challengeItem;
  bool? equippedChallengeItem;
  int? listOrder;
  int? tik;
  bool? isShoe;
  int? amount;
  InventoryItemStatModel? itemStat;
  ShopItemChallengeModel? challenge;

  InventoryItemModel({
    required this.id,
    this.userId,
    this.nftId,
    this.itemId,
    this.serialNumber,
    required this.itemGrade,
    required this.itemName,
    this.itemType,
    this.expiredDate,
    this.publishType,
    this.itemPublishType,
    required this.itemCategory,
    this.durability,
    this.abrasionRate,
    this.rewardRate,
    this.staminaReduceRate,
    required this.itemImageUrl,
    this.itemStat,
    this.description,
    this.tokenAddress,
    this.nftTokenAddress,
    this.equipped,
    this.listOrder,
    this.equippedChallengeItem,
    this.challengeItem,
    this.amount,
    this.tik = 0,
    this.isShoe = false,
    this.challenge,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
