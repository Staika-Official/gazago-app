// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionRewardModel _$CollectionRewardModelFromJson(
        Map<String, dynamic> json) =>
    CollectionRewardModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      publishType: json['publishType'] as String?,
      itemGrade: json['itemGrade'] as String?,
      luckRateFrom: (json['luckRateFrom'] as num?)?.toDouble(),
      luckRateTo: (json['luckRateTo'] as num?)?.toDouble(),
      rewardRateFrom: (json['rewardRateFrom'] as num?)?.toDouble(),
      rewardRateTo: (json['rewardRateTo'] as num?)?.toDouble(),
      minGoProfit: (json['minGoProfit'] as num?)?.toDouble(),
      maxGoProfit: (json['maxGoProfit'] as num?)?.toDouble(),
      minDurability: (json['minDurability'] as num?)?.toDouble(),
      maxDurability: (json['maxDurability'] as num?)?.toDouble(),
      minStamina: (json['minStamina'] as num?)?.toDouble(),
      maxStamina: (json['maxStamina'] as num?)?.toDouble(),
      minLuck: (json['minLuck'] as num?)?.toDouble(),
      maxLuck: (json['maxLuck'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CollectionRewardModelToJson(
        CollectionRewardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'itemGrade': instance.itemGrade,
      'publishType': instance.publishType,
      'luckRateFrom': instance.luckRateFrom,
      'luckRateTo': instance.luckRateTo,
      'rewardRateFrom': instance.rewardRateFrom,
      'rewardRateTo': instance.rewardRateTo,
      'minGoProfit': instance.minGoProfit,
      'maxGoProfit': instance.maxGoProfit,
      'minDurability': instance.minDurability,
      'maxDurability': instance.maxDurability,
      'minStamina': instance.minStamina,
      'maxStamina': instance.maxStamina,
      'minLuck': instance.minLuck,
      'maxLuck': instance.maxLuck,
    };
