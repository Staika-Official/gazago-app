// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_create_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewCreateFormModel _$CrewCreateFormModelFromJson(Map<String, dynamic> json) =>
    CrewCreateFormModel(
      name: json['name'] as String,
      challengeId: (json['challengeId'] as num).toInt(),
      crewIconId: (json['crewIconId'] as num).toInt(),
      crewCreateType: json['crewCreateType'] as String,
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CrewCreateFormModelToJson(
        CrewCreateFormModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'challengeId': instance.challengeId,
      'crewIconId': instance.crewIconId,
      'crewCreateType': instance.crewCreateType,
      'price': instance.price,
    };
