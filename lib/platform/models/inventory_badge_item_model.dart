import 'package:json_annotation/json_annotation.dart';

part 'inventory_badge_item_model.g.dart';

@JsonSerializable()
class InventoryBadgeItemModel {
  int id;
  int level;
  double rewardRate;
  double luckRate;
  String source;
  String issueType;
  String issueState;
  String issueStartedTime;
  String issueEndedTime;
  String description;
  String state;
  String address;
  String imageUrl;
  String createdBy;
  String createdDate;
  String lastModifiedBy;
  String lastModifiedDate;

  InventoryBadgeItemModel({
    required this.id,
    required this.level,
    required this.rewardRate,
    required this.luckRate,
    required this.source,
    required this.issueType,
    required this.issueState,
    required this.issueStartedTime,
    required this.issueEndedTime,
    required this.description,
    required this.state,
    required this.address,
    required this.imageUrl,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
  });

  factory InventoryBadgeItemModel.fromJson(Map<String, dynamic> json) => _$InventoryBadgeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryBadgeItemModelToJson(this);
}
