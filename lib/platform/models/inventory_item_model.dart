import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  int id;
  String serialNumber;
  String itemName;
  String itemCategory;
  double durability;
  double abrasionRate;
  double rewardRate;
  double staminaReduceRate;
  String itemImageUrl;
  bool equipped;
  int listOrder;
  int tik;
  bool isShoe;

  InventoryItemModel({
    required this.id,
    required this.serialNumber,
    required this.itemName,
    required this.itemCategory,
    required this.durability,
    required this.abrasionRate,
    required this.rewardRate,
    required this.staminaReduceRate,
    required this.itemImageUrl,
    required this.equipped,
    required this.listOrder,
    this.tik = 0,
    this.isShoe = false,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
