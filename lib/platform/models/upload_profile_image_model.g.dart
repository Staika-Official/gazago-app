// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_profile_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadProfileImageModel _$UploadProfileImageModelFromJson(
        Map<String, dynamic> json) =>
    UploadProfileImageModel(
      id: (json['id'] as num?)?.toInt(),
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$UploadProfileImageModelToJson(
        UploadProfileImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileImageUrl': instance.profileImageUrl,
    };
