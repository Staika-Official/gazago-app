// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_shoes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepairShoesModel _$RepairShoesModelFromJson(Map<String, dynamic> json) =>
    RepairShoesModel(
      repairUuid: json['repairUuid'] as String,
      repairItems: (json['repairItems'] as List<dynamic>)
          .map((e) => RepairUseItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RepairShoesModelToJson(RepairShoesModel instance) =>
    <String, dynamic>{
      'repairUuid': instance.repairUuid,
      'repairItems': instance.repairItems.map((e) => e.toJson()).toList(),
    };
