import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_badge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryBadgeModel {
  int id;
  int userId;
  String state;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  InventoryBadgeItemModel badge;

  InventoryBadgeModel({
    required this.id,
    required this.userId,
    required this.state,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    required this.badge,
  });

  factory InventoryBadgeModel.fromJson(Map<String, dynamic> json) => _$InventoryBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryBadgeModelToJson(this);
}
