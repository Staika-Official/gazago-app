import 'package:gaza_go/platform/models/equipped_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equipped_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EquippedItemModel {
  List<InventoryItemModel> items;
  EquippedBadgeItemModel? badge;

  EquippedItemModel({
    required this.items,
    this.badge,
  });

  factory EquippedItemModel.fromJson(Map<String, dynamic> json) => _$EquippedItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EquippedItemModelToJson(this);
}
