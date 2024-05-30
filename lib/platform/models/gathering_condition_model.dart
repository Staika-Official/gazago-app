import 'package:gaza_go/platform/models/gathering_compose_config_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gathering_condition_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GatheringConditionModel {
  int id;
  String type;
  double quantity;
  GatheringComposeConfigModel? item;
  GatheringComposeConfigModel? badgeComposeConfig;

  GatheringConditionModel({
    required this.id,
    required this.type,
    required this.quantity,
    this.item,
    this.badgeComposeConfig,

  });

  factory GatheringConditionModel.fromJson(Map<String, dynamic> json) => _$GatheringConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GatheringConditionModelToJson(this);
}
