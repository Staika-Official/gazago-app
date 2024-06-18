import 'package:json_annotation/json_annotation.dart';

part 'gathering_reward_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GatheringRewardItemModel {
  int id;
  String name;
  String imageUrl;
  String? description;
  String? itemGrade;
  String? publishType;
  double? minGoProfit;
  double? maxGoProfit;
  double? minDurability;
  double? maxDurability;
  double? minStamina;
  double? maxStamina;
  double? minLuck;
  double? maxLuck;

  GatheringRewardItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.publishType,
    this.itemGrade,
    this.minGoProfit,
    this.maxGoProfit,
    this.minDurability,
    this.maxDurability,
    this.minStamina,
    this.maxStamina,
    this.minLuck,
    this.maxLuck,
  });

  factory GatheringRewardItemModel.fromJson(Map<String, dynamic> json) => _$GatheringRewardItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$GatheringRewardItemModelToJson(this);
}
