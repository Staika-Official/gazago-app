// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stik_quotes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StikQuotesModel _$StikQuotesModelFromJson(Map<String, dynamic> json) =>
    StikQuotesModel(
      priceUSD: (json['priceUSD'] as num).toDouble(),
      priceKRW: (json['priceKRW'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$StikQuotesModelToJson(StikQuotesModel instance) =>
    <String, dynamic>{
      'priceUSD': instance.priceUSD,
      'priceKRW': instance.priceKRW,
      'lastUpdated': instance.lastUpdated,
    };
