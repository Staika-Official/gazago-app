// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_landing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeLandingModel _$ChallengeLandingModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeLandingModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      label: json['label'] as String?,
      openType: json['openType'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );

Map<String, dynamic> _$ChallengeLandingModelToJson(
        ChallengeLandingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'label': instance.label,
      'openType': instance.openType,
      'linkUrl': instance.linkUrl,
    };
