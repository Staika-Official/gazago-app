// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPriceModel _$TokenPriceModelFromJson(Map<String, dynamic> json) =>
    TokenPriceModel(
      price: (json['price'] as num?)?.toDouble(),
      percentChange1h: (json['percentChange1h'] as num?)?.toDouble(),
      percentChange24h: (json['percentChange24h'] as num?)?.toDouble(),
      percentChange7d: (json['percentChange7d'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] as String?,
    )..volume24h = (json['volume24h'] as num?)?.toDouble();

Map<String, dynamic> _$TokenPriceModelToJson(TokenPriceModel instance) =>
    <String, dynamic>{
      'price': instance.price,
      'volume24h': instance.volume24h,
      'percentChange1h': instance.percentChange1h,
      'percentChange24h': instance.percentChange24h,
      'percentChange7d': instance.percentChange7d,
      'lastUpdated': instance.lastUpdated,
    };
