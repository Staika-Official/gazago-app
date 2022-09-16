import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  String name;
  String itemName;
  String itemImageUrl;
  double currentStat;
  bool isShoe;

  InventoryItemModel({
    required this.name,
    required this.currentStat,
    this.isShoe = false,
    required this.itemName,
    required this.itemImageUrl,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
