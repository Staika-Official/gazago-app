import 'package:json_annotation/json_annotation.dart';

part 'shop_item_purchase_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemPurchaseResponseModel {
  int id;
  int userId;
  String serialNumber;
  String itemName;
  String itemImageUrl;
  String itemCategory;
  String itemGrade;
  double durability;
  double abrasionRate;
  double rewardRate;
  double staminaReduceRate;
  String description;

  ShopItemPurchaseResponseModel({
    required this.id,
    required this.userId,
    required this.serialNumber,
    required this.itemName,
    required this.itemImageUrl,
    required this.itemCategory,
    required this.itemGrade,
    required this.durability,
    required this.abrasionRate,
    required this.rewardRate,
    required this.staminaReduceRate,
    required this.description,
  });

  factory ShopItemPurchaseResponseModel.fromJson(Map<String, dynamic> json) => _$ShopItemPurchaseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemPurchaseResponseModelToJson(this);
}
