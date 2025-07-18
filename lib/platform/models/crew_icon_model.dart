import 'package:json_annotation/json_annotation.dart';

part 'crew_icon_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewIconModel {
  int id;
  String name;
  String imageUrl;
  bool activated;
  int listOrder;

  CrewIconModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.activated,
    required this.listOrder,
  });

  factory CrewIconModel.fromJson(Map<String, dynamic> json) => _$CrewIconModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewIconModelToJson(this);
}
