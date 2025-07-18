// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftAttributeModel _$NftAttributeModelFromJson(Map<String, dynamic> json) =>
    NftAttributeModel(
      trait_type: json['trait_type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$NftAttributeModelToJson(NftAttributeModel instance) =>
    <String, dynamic>{
      'trait_type': instance.trait_type,
      'value': instance.value,
    };
