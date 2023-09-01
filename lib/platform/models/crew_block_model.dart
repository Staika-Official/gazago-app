import 'package:json_annotation/json_annotation.dart';

part 'crew_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewBlockModel {
  int id;
  String type;
  int quantity;

  CrewBlockModel({
    required this.id,
    required this.type,
    required this.quantity,
  });

  factory CrewBlockModel.fromJson(Map<String, dynamic> json) => _$CrewBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewBlockModelToJson(this);
}
