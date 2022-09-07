import 'package:json_annotation/json_annotation.dart';

part 'stat_model.g.dart';

@JsonSerializable()
class StatModel {
  String name;
  double currentStat;

  StatModel({
    required this.name,
    required this.currentStat,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) => _$StatModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatModelToJson(this);
}
