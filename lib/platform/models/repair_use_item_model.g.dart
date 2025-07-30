// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_use_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepairUseItemModel _$RepairUseItemModelFromJson(Map<String, dynamic> json) =>
    RepairUseItemModel(
      userItemId: (json['userItemId'] as num?)?.toInt(),
      spendItemAmount: (json['spendItemAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RepairUseItemModelToJson(RepairUseItemModel instance) =>
    <String, dynamic>{
      'userItemId': instance.userItemId,
      'spendItemAmount': instance.spendItemAmount,
    };
