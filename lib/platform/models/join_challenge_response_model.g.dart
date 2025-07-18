// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_challenge_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinChallengeResponseModel _$JoinChallengeResponseModelFromJson(
        Map<String, dynamic> json) =>
    JoinChallengeResponseModel(
      challengeId: (json['challengeId'] as num).toInt(),
      challengeLanding: json['challengeLanding'] == null
          ? null
          : ChallengeLandingModel.fromJson(
              json['challengeLanding'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JoinChallengeResponseModelToJson(
        JoinChallengeResponseModel instance) =>
    <String, dynamic>{
      'challengeId': instance.challengeId,
      'challengeLanding': instance.challengeLanding?.toJson(),
    };
