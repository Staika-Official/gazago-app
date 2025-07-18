// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) =>
    CollectionModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      gatheringDifficultyType: json['gatheringDifficultyType'] as String,
      imageUrl: json['imageUrl'] as String,
      grayscaleImageUrl: json['grayscaleImageUrl'] as String,
      fromDateTime: json['fromDateTime'] as String?,
      toDateTime: json['toDateTime'] as String?,
      gatheringConditions: (json['gatheringConditions'] as List<dynamic>)
          .map((e) =>
              GatheringConditionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      gatheringReward: GatheringConditionModel.fromJson(
          json['gatheringReward'] as Map<String, dynamic>),
      alreadyIssued: json['alreadyIssued'] as bool,
      getAble: json['getAble'] as bool?,
      completeQuantity: (json['completeQuantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CollectionModelToJson(CollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'gatheringDifficultyType': instance.gatheringDifficultyType,
      'imageUrl': instance.imageUrl,
      'grayscaleImageUrl': instance.grayscaleImageUrl,
      'fromDateTime': instance.fromDateTime,
      'toDateTime': instance.toDateTime,
      'gatheringConditions':
          instance.gatheringConditions.map((e) => e.toJson()).toList(),
      'gatheringReward': instance.gatheringReward.toJson(),
      'alreadyIssued': instance.alreadyIssued,
      'getAble': instance.getAble,
      'completeQuantity': instance.completeQuantity,
    };
