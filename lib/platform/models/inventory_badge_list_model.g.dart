// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_badge_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryBadgeListModel _$InventoryBadgeListModelFromJson(
        Map<String, dynamic> json) =>
    InventoryBadgeListModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      badgeId: (json['badgeId'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      state: json['state'] as String,
      imageUrl: json['imageUrl'] as String?,
      rewardRate: (json['rewardRate'] as num).toDouble(),
      luckRate: (json['luckRate'] as num).toDouble(),
      name: json['name'] as String?,
      issueType: json['issueType'] as String,
      issueEndedTime: json['issueEndedTime'] as String?,
    );

Map<String, dynamic> _$InventoryBadgeListModelToJson(
        InventoryBadgeListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'badgeId': instance.badgeId,
      'level': instance.level,
      'state': instance.state,
      'imageUrl': instance.imageUrl,
      'rewardRate': instance.rewardRate,
      'luckRate': instance.luckRate,
      'name': instance.name,
      'issueType': instance.issueType,
      'issueEndedTime': instance.issueEndedTime,
    };
