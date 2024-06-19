import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_reward_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionRewardModel {
  int id;
  String type;
  String name;
  String description;
  String imageUrl;
  String? itemGrade;
  String? publishType;
  double? luckRateFrom;
  double? luckRateTo;
  double? rewardRateFrom;
  double? rewardRateTo;
  double? minGoProfit;
  double? maxGoProfit;
  double? minDurability;
  double? maxDurability;
  double? minStamina;
  double? maxStamina;
  double? minLuck;
  double? maxLuck;


  CollectionRewardModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.publishType,
    this.itemGrade,
    this.luckRateFrom,
    this.luckRateTo,
    this.rewardRateFrom,
    this.rewardRateTo,
    this.minGoProfit,
    this.maxGoProfit,
    this.minDurability,
    this.maxDurability,
    this.minStamina,
    this.maxStamina,
    this.minLuck,
    this.maxLuck,
  });

  factory CollectionRewardModel.fromJson(Map<String, dynamic> json) => _$CollectionRewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionRewardModelToJson(this);
}
