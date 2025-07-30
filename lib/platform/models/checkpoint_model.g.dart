// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpointModel _$CheckpointModelFromJson(Map<String, dynamic> json) =>
    CheckpointModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CheckpointModelToJson(CheckpointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'radius': instance.radius,
    };
