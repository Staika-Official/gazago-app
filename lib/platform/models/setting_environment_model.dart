import 'package:json_annotation/json_annotation.dart';

part 'setting_environment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SettingEnvironmentModel {
  String key;
  String value;

  SettingEnvironmentModel({
    required this.key,
    required this.value,
  });

  factory SettingEnvironmentModel.fromJson(Map<String, dynamic> json) => _$SettingEnvironmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingEnvironmentModelToJson(this);
}
