// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryBadgeModel _$InventoryBadgeModelFromJson(Map<String, dynamic> json) =>
    InventoryBadgeModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      state: json['state'] as String,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
      badge: InventoryBadgeItemModel.fromJson(
          json['badge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InventoryBadgeModelToJson(
        InventoryBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'state': instance.state,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'badge': instance.badge.toJson(),
    };
