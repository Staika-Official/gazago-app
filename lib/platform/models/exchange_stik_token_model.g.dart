// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_stik_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeStikTokenModel _$ExchangeStikTokenModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeStikTokenModel(
      quotes: json['quotes'] == null
          ? null
          : ExchangeStikQuotesModel.fromJson(
              json['quotes'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map(
              (e) => ExchangeStikPriceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExchangeStikTokenModelToJson(
        ExchangeStikTokenModel instance) =>
    <String, dynamic>{
      'quotes': instance.quotes?.toJson(),
      'products': instance.products.map((e) => e.toJson()).toList(),
    };
