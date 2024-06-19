import 'package:gaza_go/platform/models/gathering_reward_badge_model.dart';
import 'package:gaza_go/platform/models/gathering_reward_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gathering_condition_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GatheringConditionModel {
  int id;
  String type;
  double quantity;
  GatheringRewardItemModel? item;
  GatheringRewardBadgeModel? badgeComposeConfig;
  int? completeAmount;

  GatheringConditionModel({
    required this.id,
    required this.type,
    required this.quantity,
    this.item,
    this.badgeComposeConfig,
    this.completeAmount,

  });

  factory GatheringConditionModel.fromJson(Map<String, dynamic> json) => _$GatheringConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GatheringConditionModelToJson(this);
}
