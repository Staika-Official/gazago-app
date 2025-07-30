// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeDetailModel _$ChallengeDetailModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeDetailModel(
      challenge: json['challenge'] == null
          ? null
          : ChallengeInfoModel.fromJson(
              json['challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChallengeDetailModelToJson(
        ChallengeDetailModel instance) =>
    <String, dynamic>{
      'challenge': instance.challenge?.toJson(),
    };
