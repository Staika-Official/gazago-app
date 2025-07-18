import 'package:json_annotation/json_annotation.dart';

part 'upload_profile_image_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadProfileImageModel {
  int? id;
  String? profileImageUrl;

  UploadProfileImageModel({
    this.id,
    this.profileImageUrl,
  });

  factory UploadProfileImageModel.fromJson(Map<String, dynamic> json) => _$UploadProfileImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadProfileImageModelToJson(this);
}
