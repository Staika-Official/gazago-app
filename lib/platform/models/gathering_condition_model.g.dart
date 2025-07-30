// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering_condition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatheringConditionModel _$GatheringConditionModelFromJson(
        Map<String, dynamic> json) =>
    GatheringConditionModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      item: json['item'] == null
          ? null
          : GatheringRewardItemModel.fromJson(
              json['item'] as Map<String, dynamic>),
      badgeComposeConfig: json['badgeComposeConfig'] == null
          ? null
          : GatheringRewardBadgeModel.fromJson(
              json['badgeComposeConfig'] as Map<String, dynamic>),
      completeAmount: (json['completeAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GatheringConditionModelToJson(
        GatheringConditionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'quantity': instance.quantity,
      'item': instance.item?.toJson(),
      'badgeComposeConfig': instance.badgeComposeConfig?.toJson(),
      'completeAmount': instance.completeAmount,
    };
