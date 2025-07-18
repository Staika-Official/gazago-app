// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipped_badge_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquippedBadgeItemModel _$EquippedBadgeItemModelFromJson(
        Map<String, dynamic> json) =>
    EquippedBadgeItemModel(
      id: (json['id'] as num).toInt(),
      badgeId: (json['badgeId'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      rewardRate: (json['rewardRate'] as num).toDouble(),
      luckRate: (json['luckRate'] as num).toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$EquippedBadgeItemModelToJson(
        EquippedBadgeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'badgeId': instance.badgeId,
      'level': instance.level,
      'imageUrl': instance.imageUrl,
      'rewardRate': instance.rewardRate,
      'luckRate': instance.luckRate,
      'description': instance.description,
    };
