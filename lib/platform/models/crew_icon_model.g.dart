// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_icon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewIconModel _$CrewIconModelFromJson(Map<String, dynamic> json) =>
    CrewIconModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      activated: json['activated'] as bool,
      listOrder: (json['listOrder'] as num).toInt(),
    );

Map<String, dynamic> _$CrewIconModelToJson(CrewIconModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'activated': instance.activated,
      'listOrder': instance.listOrder,
    };
