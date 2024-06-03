import 'package:gaza_go/platform/models/gathering_compose_config_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_items_summaries_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserItemsSummariesModel {
  int id;
  int itemId;
  int amount;
  bool equipped;

  UserItemsSummariesModel({
    required this.id,
    required this.itemId,
    required this.amount,
    required this.equipped,

  });

  factory UserItemsSummariesModel.fromJson(Map<String, dynamic> json) => _$UserItemsSummariesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserItemsSummariesModelToJson(this);
}
