// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_meta_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftMetaData _$NftMetaDataFromJson(Map<String, dynamic> json) => NftMetaData(
      name: json['name'] as String?,
      image: json['image'] as String?,
      properties: json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
      collection: json['collection'] == null
          ? null
          : Collection.fromJson(json['collection'] as Map<String, dynamic>),
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => Attribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NftMetaDataToJson(NftMetaData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'properties': instance.properties?.toJson(),
      'collection': instance.collection?.toJson(),
      'attributes': instance.attributes?.map((e) => e.toJson()).toList(),
    };

Attribute _$AttributeFromJson(Map<String, dynamic> json) => Attribute(
      traitType: json['trait_type'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'trait_type': instance.traitType,
      'value': instance.value,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      family: json['family'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'family': instance.family,
      'name': instance.name,
    };
