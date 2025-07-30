// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatModel _$StatModelFromJson(Map<String, dynamic> json) => StatModel(
      name: json['name'] as String,
      currentStat: (json['currentStat'] as num).toDouble(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$StatModelToJson(StatModel instance) => <String, dynamic>{
      'name': instance.name,
      'currentStat': instance.currentStat,
      'type': instance.type,
    };
