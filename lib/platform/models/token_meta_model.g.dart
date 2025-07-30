// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenMetaModel _$TokenMetaModelFromJson(Map<String, dynamic> json) =>
    TokenMetaModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
    );

Map<String, dynamic> _$TokenMetaModelToJson(TokenMetaModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
    };
