// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionItemModel _$PermissionItemModelFromJson(Map<String, dynamic> json) =>
    PermissionItemModel(
      iconPath: json['iconPath'] as String,
      permissionName: json['permissionName'] as String,
      isRequired: json['isRequired'] as bool,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PermissionItemModelToJson(
        PermissionItemModel instance) =>
    <String, dynamic>{
      'iconPath': instance.iconPath,
      'permissionName': instance.permissionName,
      'isRequired': instance.isRequired,
      'description': instance.description,
    };
