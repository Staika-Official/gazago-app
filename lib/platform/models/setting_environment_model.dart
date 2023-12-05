import 'package:gaza_go/platform/models/nft_collection_model.dart';
import 'package:gaza_go/platform/models/nft_properties_model.dart';
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
