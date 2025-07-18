import 'package:json_annotation/json_annotation.dart';

part 'repair_use_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RepairUseItemModel {
  int? userItemId;
  int? spendItemAmount;

  RepairUseItemModel({
    this.userItemId,
    this.spendItemAmount,
  });

  factory RepairUseItemModel.fromJson(Map<String, dynamic> json) => _$RepairUseItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RepairUseItemModelToJson(this);
}
