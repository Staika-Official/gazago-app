import 'package:json_annotation/json_annotation.dart';

part 'gathering_compose_config_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GatheringComposeConfigModel {
  int id;
  String name;
  String imageUrl;

  GatheringComposeConfigModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory GatheringComposeConfigModel.fromJson(Map<String, dynamic> json) => _$GatheringComposeConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$GatheringComposeConfigModelToJson(this);
}
