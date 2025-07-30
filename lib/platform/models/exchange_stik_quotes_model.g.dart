// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_stik_quotes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeStikQuotesModel _$ExchangeStikQuotesModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeStikQuotesModel(
      priceKRW: (json['priceKRW'] as num?)?.toDouble(),
      priceUSD: (json['priceUSD'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] as String?,
    );

Map<String, dynamic> _$ExchangeStikQuotesModelToJson(
        ExchangeStikQuotesModel instance) =>
    <String, dynamic>{
      'priceKRW': instance.priceKRW,
      'priceUSD': instance.priceUSD,
      'lastUpdated': instance.lastUpdated,
    };
