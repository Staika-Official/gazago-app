// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_badge_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryBadgeItemModel _$InventoryBadgeItemModelFromJson(
        Map<String, dynamic> json) =>
    InventoryBadgeItemModel(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      rewardRate: (json['rewardRate'] as num).toDouble(),
      luckRate: (json['luckRate'] as num).toDouble(),
      source: json['source'] as String?,
      name: json['name'] as String?,
      issueType: json['issueType'] as String,
      issueState: json['issueState'] as String,
      issueStartedTime: json['issueStartedTime'] as String,
      issueEndedTime: json['issueEndedTime'] as String,
      description: json['description'] as String?,
      state: json['state'] as String,
      address: json['address'] as String?,
      imageUrl: json['imageUrl'] as String,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
    );

Map<String, dynamic> _$InventoryBadgeItemModelToJson(
        InventoryBadgeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'rewardRate': instance.rewardRate,
      'luckRate': instance.luckRate,
      'source': instance.source,
      'name': instance.name,
      'issueType': instance.issueType,
      'issueState': instance.issueState,
      'issueStartedTime': instance.issueStartedTime,
      'issueEndedTime': instance.issueEndedTime,
      'description': instance.description,
      'state': instance.state,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
    };
