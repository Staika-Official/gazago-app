// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeBadgeModel _$ChallengeBadgeModelFromJson(Map<String, dynamic> json) =>
    ChallengeBadgeModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      limitedCount: (json['limitedCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChallengeBadgeModelToJson(
        ChallengeBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'limitedCount': instance.limitedCount,
    };
