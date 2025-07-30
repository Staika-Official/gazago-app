// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: (json['id'] as num).toInt(),
      challengeType: json['challengeType'] as String,
      exerciseTypes: (json['exerciseTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      simpleTitle: json['simpleTitle'] as String,
      subTitle: json['subTitle'] as String,
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String,
      limitedPeriod: json['limitedPeriod'] as bool,
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeType': instance.challengeType,
      'exerciseTypes': instance.exerciseTypes,
      'simpleTitle': instance.simpleTitle,
      'subTitle': instance.subTitle,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'thumbnailImageUrl': instance.thumbnailImageUrl,
      'limitedPeriod': instance.limitedPeriod,
    };
