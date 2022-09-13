import 'package:json_annotation/json_annotation.dart';

part 'inventory_badge_model.g.dart';

@JsonSerializable()
class InventoryBadgeModel {
  int id;
  String badgeImageUrl;
  String badgeName;
  int effect;
  String getDate;
  int level;

  InventoryBadgeModel({
    required this.id,
    required this.badgeImageUrl,
    required this.badgeName,
    required this.effect,
    required this.getDate,
    required this.level,
  });

  factory InventoryBadgeModel.fromJson(Map<String, dynamic> json) => _$InventoryBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryBadgeModelToJson(this);
}
