// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering_reward_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatheringRewardItemModel _$GatheringRewardItemModelFromJson(
        Map<String, dynamic> json) =>
    GatheringRewardItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      publishType: json['publishType'] as String?,
      itemGrade: json['itemGrade'] as String?,
      minGoProfit: (json['minGoProfit'] as num?)?.toDouble(),
      maxGoProfit: (json['maxGoProfit'] as num?)?.toDouble(),
      minDurability: (json['minDurability'] as num?)?.toDouble(),
      maxDurability: (json['maxDurability'] as num?)?.toDouble(),
      minStamina: (json['minStamina'] as num?)?.toDouble(),
      maxStamina: (json['maxStamina'] as num?)?.toDouble(),
      minLuck: (json['minLuck'] as num?)?.toDouble(),
      maxLuck: (json['maxLuck'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GatheringRewardItemModelToJson(
        GatheringRewardItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'itemGrade': instance.itemGrade,
      'publishType': instance.publishType,
      'minGoProfit': instance.minGoProfit,
      'maxGoProfit': instance.maxGoProfit,
      'minDurability': instance.minDurability,
      'maxDurability': instance.maxDurability,
      'minStamina': instance.minStamina,
      'maxStamina': instance.maxStamina,
      'minLuck': instance.minLuck,
      'maxLuck': instance.maxLuck,
    };
