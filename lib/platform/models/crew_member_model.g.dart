// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewMemberModel _$CrewMemberModelFromJson(Map<String, dynamic> json) =>
    CrewMemberModel(
      blockQuantity: (json['blockQuantity'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      inviteCount: (json['inviteCount'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CrewMemberModelToJson(CrewMemberModel instance) =>
    <String, dynamic>{
      'blockQuantity': instance.blockQuantity,
      'imageUrl': instance.imageUrl,
      'inviteCount': instance.inviteCount,
      'nickname': instance.nickname,
      'userId': instance.userId,
    };
