import 'package:json_annotation/json_annotation.dart';

part 'iap_valid_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IapValidModel {
  bool valid;
  String state;

  IapValidModel({
    required this.valid,
    required this.state,
  });

  factory IapValidModel.fromJson(Map<String, dynamic> json) => _$IapValidModelFromJson(json);

  Map<String, dynamic> toJson() => _$IapValidModelToJson(this);
}
