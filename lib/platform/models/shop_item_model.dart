import 'package:gaza_go/platform/models/shop_item_challenge_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemModel {
  int id;
  int? challengeId;
  String name;
  String? itemImageUrl;
  String? challengeBannerImageUrl;
  String? itemCategory;
  String itemGrade;
  double? minGoProfit;
  double? maxGoProfit;
  double? minDurability;
  double? maxDurability;
  double? minStamina;
  double? maxStamina;
  double? minLuck;
  double? maxLuck;
  double price;
  String? itemLabel;
  String? description;
  String? publishType;
  String? tradeSymbol;
  ShopItemChallengeModel? challenge;

  ShopItemModel({
    required this.id,
    required this.name,
    this.challengeId,
    this.challengeBannerImageUrl,
    this.itemImageUrl,
    this.itemCategory,
    required this.itemGrade,
    this.minGoProfit = 0,
    this.maxGoProfit = 0,
    this.minDurability = 0,
    this.maxDurability = 0,
    this.minStamina = 0,
    this.maxStamina = 0,
    this.minLuck = 0,
    this.maxLuck = 0,
    required this.price,
    this.itemLabel,
    this.description,
    this.publishType,
    this.tradeSymbol,
    this.challenge,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) => _$ShopItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemModelToJson(this);
}
