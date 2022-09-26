import 'package:json_annotation/json_annotation.dart';

part 'repair_shoes_model.g.dart';

@JsonSerializable()
class RepairShoesModel {
  int id;
  int durability;
  int tik;

  RepairShoesModel({
    required this.id,
    required this.durability,
    required this.tik,
  });

  factory RepairShoesModel.fromJson(Map<String, dynamic> json) => _$RepairShoesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RepairShoesModelToJson(this);
}
