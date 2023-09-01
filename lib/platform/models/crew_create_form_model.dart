import 'package:json_annotation/json_annotation.dart';

part 'crew_create_form_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewCreateFormModel {
  String name;
  int challengeId;
  int crewIconId;
  String crewCreateType;
  double? price;

  CrewCreateFormModel({
    required this.name,
    required this.challengeId,
    required this.crewIconId,
    required this.crewCreateType,
    this.price,
  });

  factory CrewCreateFormModel.fromJson(Map<String, dynamic> json) => _$CrewCreateFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewCreateFormModelToJson(this);
}
