// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewBlockModel _$CrewBlockModelFromJson(Map<String, dynamic> json) =>
    CrewBlockModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CrewBlockModelToJson(CrewBlockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'quantity': instance.quantity,
    };
