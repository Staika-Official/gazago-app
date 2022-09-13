import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  String name;
  double currentStat;
  bool isShoe;

  InventoryItemModel({
    required this.name,
    required this.currentStat,
    this.isShoe = false,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
