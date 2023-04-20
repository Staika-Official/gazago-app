import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_stat_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryItemStatModel {
  double? goProfit;
  double? durability;
  double? stamina;
  double? luck;

  InventoryItemStatModel({
    this.goProfit,
    this.durability,
    this.stamina,
    this.luck,
  });

  factory InventoryItemStatModel.fromJson(Map<String, dynamic> json) => _$InventoryItemStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemStatModelToJson(this);
}
