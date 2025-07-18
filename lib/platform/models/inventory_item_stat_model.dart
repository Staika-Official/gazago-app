import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_stat_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class InventoryItemStatModel {
  @HiveField(0)
  double? goProfit;
  @HiveField(1)
  double? durability;
  @HiveField(2)
  double? stamina;
  @HiveField(3)
  double? luck;
  @HiveField(4)
  double? recoveryStamina;
  @HiveField(5)
  double? repairDurability;

  InventoryItemStatModel({
    this.goProfit,
    this.durability,
    this.stamina,
    this.luck,
    this.recoveryStamina,
    this.repairDurability,
  });

  factory InventoryItemStatModel.fromJson(Map<String, dynamic> json) => _$InventoryItemStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemStatModelToJson(this);
}
