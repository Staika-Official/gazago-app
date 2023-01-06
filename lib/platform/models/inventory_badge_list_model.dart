import 'package:json_annotation/json_annotation.dart';

part 'inventory_badge_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryBadgeListModel {
  int id;
  int userId;
  int badgeId;
  int level;
  String state;
  String? imageUrl;
  num rewardRate;
  num luckRate;
  String? name;
  String issueType;
  String? issueEndedTime;

  InventoryBadgeListModel(
      {required this.id,
      required this.userId,
      required this.badgeId,
      required this.level,
      required this.state,
      this.imageUrl,
      required this.rewardRate,
      required this.luckRate,
      this.name,
      required this.issueType,
      this.issueEndedTime});

  factory InventoryBadgeListModel.fromJson(Map<String, dynamic> json) => _$InventoryBadgeListModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryBadgeListModelToJson(this);
}
