import 'package:json_annotation/json_annotation.dart';

part 'shop_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemModel {
  int id;
  String name;
  String? itemImageUrl;
  String? itemCategory;
  String itemGrade;
  double toRewardRate;
  double fromRewardRate;
  double toAbrasionRate;
  double fromAbrasionRate;
  double toStaminaReduceRate;
  double fromStaminaReduceRate;
  double price;
  String? itemLabel;
  String? description;

  ShopItemModel({
    required this.id,
    required this.name,
    this.itemImageUrl,
    this.itemCategory,
    required this.itemGrade,
    required this.toRewardRate,
    required this.fromRewardRate,
    required this.toAbrasionRate,
    required this.fromAbrasionRate,
    required this.toStaminaReduceRate,
    required this.fromStaminaReduceRate,
    required this.price,
    this.itemLabel,
    this.description,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) => _$ShopItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemModelToJson(this);
}
