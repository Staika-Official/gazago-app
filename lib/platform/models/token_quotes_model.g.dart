// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_quotes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenQuotesModel _$TokenQuotesModelFromJson(Map<String, dynamic> json) =>
    TokenQuotesModel(
      currency: json['currency'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] as String?,
    );

Map<String, dynamic> _$TokenQuotesModelToJson(TokenQuotesModel instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'price': instance.price,
      'lastUpdated': instance.lastUpdated,
    };
