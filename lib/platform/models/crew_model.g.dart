// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewModel _$CrewModelFromJson(Map<String, dynamic> json) => CrewModel(
      blockQuantity: (json['blockQuantity'] as num?)?.toInt(),
      crewFounderNickName: json['crewFounderNickName'] as String?,
      crewBuffLevel: json['crewBuffLevel'] as String?,
      crewFounderId: (json['crewFounderId'] as num?)?.toInt(),
      crewMemberList: (json['crewMemberList'] as List<dynamic>?)
          ?.map((e) => CrewMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      iconImageUrl: json['iconImageUrl'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      crewRecruitStatus: json['crewRecruitStatus'] as String?,
      crewRelayStatus: json['crewRelayStatus'] as String?,
    );

Map<String, dynamic> _$CrewModelToJson(CrewModel instance) => <String, dynamic>{
      'blockQuantity': instance.blockQuantity,
      'crewFounderNickName': instance.crewFounderNickName,
      'crewBuffLevel': instance.crewBuffLevel,
      'crewFounderId': instance.crewFounderId,
      'crewMemberList':
          instance.crewMemberList?.map((e) => e.toJson()).toList(),
      'iconImageUrl': instance.iconImageUrl,
      'id': instance.id,
      'name': instance.name,
      'crewRecruitStatus': instance.crewRecruitStatus,
      'crewRelayStatus': instance.crewRelayStatus,
    };
