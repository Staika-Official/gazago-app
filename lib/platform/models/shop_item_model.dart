import 'package:json_annotation/json_annotation.dart';

part 'shop_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemModel {
  int id;
  String name;
  String itemImageUrl;
  String itemGrade;
  int price;
  String itemCategory;
  String staminaReduceRate;
  String durability;
  String rewardRate;
  String? description;

  ShopItemModel({
    required this.id,
    required this.itemGrade,
    required this.name,
    required this.itemCategory,
    required this.durability,
    required this.rewardRate,
    required this.staminaReduceRate,
    required this.itemImageUrl,
    required this.price,
    this.description,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) => _$ShopItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemModelToJson(this);
}
