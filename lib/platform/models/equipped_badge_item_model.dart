import 'package:json_annotation/json_annotation.dart';

part 'equipped_badge_item_model.g.dart';

@JsonSerializable()
class EquippedBadgeItemModel {
  int id;
  int badgeId;
  int level;
  String imageUrl;
  double rewardRate;
  double luckRate;
  String? description;

  EquippedBadgeItemModel({
    required this.id,
    required this.badgeId,
    required this.level,
    required this.imageUrl,
    required this.rewardRate,
    required this.luckRate,
    this.description,
  });

  factory EquippedBadgeItemModel.fromJson(Map<String, dynamic> json) => _$EquippedBadgeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EquippedBadgeItemModelToJson(this);
}
