// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionAdModel _$PromotionAdModelFromJson(Map<String, dynamic> json) =>
    PromotionAdModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      subImageUrl: json['subImageUrl'] as String?,
      label: json['label'] as String?,
      openType: json['openType'] as String?,
      linkUrl: json['linkUrl'] as String?,
      referenceId: (json['referenceId'] as num?)?.toInt(),
      listOrder: (json['listOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PromotionAdModelToJson(PromotionAdModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'subImageUrl': instance.subImageUrl,
      'label': instance.label,
      'openType': instance.openType,
      'linkUrl': instance.linkUrl,
      'referenceId': instance.referenceId,
      'listOrder': instance.listOrder,
    };
