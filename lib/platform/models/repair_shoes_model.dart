import 'package:json_annotation/json_annotation.dart';

part 'repair_shoes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RepairShoesModel {
  int? id;
  int? durability;
  int? feeTik;

  RepairShoesModel({
    this.id,
    this.durability,
    this.feeTik,
  });

  factory RepairShoesModel.fromJson(Map<String, dynamic> json) => _$RepairShoesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RepairShoesModelToJson(this);
}
