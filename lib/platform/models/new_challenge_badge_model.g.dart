// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_challenge_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewChallengeBadgeModel _$NewChallengeBadgeModelFromJson(
        Map<String, dynamic> json) =>
    NewChallengeBadgeModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      limitedCount: (json['limitedCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewChallengeBadgeModelToJson(
        NewChallengeBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'limitedCount': instance.limitedCount,
    };
