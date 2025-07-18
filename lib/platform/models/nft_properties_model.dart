import 'package:gaza_go/platform/models/nft_files_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_properties_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Properties {
  List<Files>? files;

  Properties({
    this.files,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => _$PropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}
