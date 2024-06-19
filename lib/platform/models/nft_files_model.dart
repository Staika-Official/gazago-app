import 'package:json_annotation/json_annotation.dart';

part 'nft_files_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Files {
  dynamic type;
  String? uri;

  Files({
    this.type,
    this.uri,
  });

  factory Files.fromJson(Map<String, dynamic> json) => _$FilesFromJson(json);

  Map<String, dynamic> toJson() => _$FilesToJson(this);
}
