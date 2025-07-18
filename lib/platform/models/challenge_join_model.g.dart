// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_join_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeJoinModel _$ChallengeJoinModelFromJson(Map<String, dynamic> json) =>
    ChallengeJoinModel(
      challengeActivationType: json['challengeActivationType'] as String,
      code: json['code'] as String?,
      entryFee: (json['entryFee'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChallengeJoinModelToJson(ChallengeJoinModel instance) =>
    <String, dynamic>{
      'challengeActivationType': instance.challengeActivationType,
      'code': instance.code,
      'entryFee': instance.entryFee,
      'itemId': instance.itemId,
    };
