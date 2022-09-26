import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equipped_item_model.g.dart';

@JsonSerializable()
class EquippedItemModel {
  List<InventoryItemModel> items;
  InventoryBadgeItemModel badge;

  EquippedItemModel({
    required this.items,
    required this.badge,
  });

  factory EquippedItemModel.fromJson(Map<String, dynamic> json) => _$EquippedItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EquippedItemModelToJson(this);
}
