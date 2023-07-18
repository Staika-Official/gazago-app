import 'package:gaza_go/platform/models/repair_use_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repair_shoes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RepairShoesModel {
  String repairUuid;
  List<RepairUseItemModel> repairItems;

  RepairShoesModel({
    required this.repairUuid,
    required this.repairItems,
  });

  factory RepairShoesModel.fromJson(Map<String, dynamic> json) => _$RepairShoesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RepairShoesModelToJson(this);
}
