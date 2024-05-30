import 'package:json_annotation/json_annotation.dart';

part 'user_summaries_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSummariesItemModel {
  int id;
  int itemId;
  int amount;
  bool equipped;


  UserSummariesItemModel({
    required this.id,
    required this.itemId,
    required this.amount,
    required this.equipped,
  });

  factory UserSummariesItemModel.fromJson(Map<String, dynamic> json) => _$UserSummariesItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummariesItemModelToJson(this);
}
