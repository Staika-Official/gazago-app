// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipped_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquippedItemModel _$EquippedItemModelFromJson(Map<String, dynamic> json) =>
    EquippedItemModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      badge: json['badge'] == null
          ? null
          : EquippedBadgeItemModel.fromJson(
              json['badge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EquippedItemModelToJson(EquippedItemModel instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'badge': instance.badge?.toJson(),
    };
