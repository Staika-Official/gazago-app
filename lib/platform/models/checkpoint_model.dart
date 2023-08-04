import 'package:json_annotation/json_annotation.dart';

part 'checkpoint_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckpointModel {
  int? id;
  String? name;
  double? lat;
  double? lon;
  double? radius;

  CheckpointModel({
    this.id,
    this.name,
    this.lat,
    this.lon,
    this.radius,
  });

  factory CheckpointModel.fromJson(Map<String, dynamic> json) => _$CheckpointModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointModelToJson(this);
}
