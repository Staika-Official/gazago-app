// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_crew_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyCrewListModel _$CompanyCrewListModelFromJson(
        Map<String, dynamic> json) =>
    CompanyCrewListModel(
      crewId: (json['crewId'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      crewName: json['crewName'] as String,
      crewIconImageUrl: json['crewIconImageUrl'] as String,
      listFixed: json['listFixed'] as bool?,
    );

Map<String, dynamic> _$CompanyCrewListModelToJson(
        CompanyCrewListModel instance) =>
    <String, dynamic>{
      'crewId': instance.crewId,
      'distance': instance.distance,
      'crewName': instance.crewName,
      'crewIconImageUrl': instance.crewIconImageUrl,
      'listFixed': instance.listFixed,
    };
