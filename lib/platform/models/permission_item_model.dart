import 'package:json_annotation/json_annotation.dart';

part 'permission_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PermissionItemModel {
  String iconPath;
  String permissionName;
  bool isRequired;
  String description;

  PermissionItemModel({
    required this.iconPath,
    required this.permissionName,
    required this.isRequired,
    required this.description,
  });

  factory PermissionItemModel.fromJson(Map<String, dynamic> json) => _$PermissionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionItemModelToJson(this);
}
