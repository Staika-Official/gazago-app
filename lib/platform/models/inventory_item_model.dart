import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  int id;
  int? userId;
  String serialNumber;
  String itemName;
  String itemCategory;
  String itemGrade;
  double durability;
  double abrasionRate;
  double rewardRate;
  double staminaReduceRate;
  String itemImageUrl;
  String? description;
  bool? equipped;
  int? listOrder;
  int? tik;
  bool? isShoe;

  InventoryItemModel({
    required this.id,
    this.userId,
    required this.serialNumber,
    required this.itemGrade,
    required this.itemName,
    required this.itemCategory,
    required this.durability,
    required this.abrasionRate,
    required this.rewardRate,
    required this.staminaReduceRate,
    required this.itemImageUrl,
    this.description,
    this.equipped,
    this.listOrder,
    this.tik = 0,
    this.isShoe = false,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
