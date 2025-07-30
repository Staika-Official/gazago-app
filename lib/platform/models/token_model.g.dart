// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      address: json['address'] as String?,
      logoUrl: json['logoUrl'] as String?,
      quotes: (json['quotes'] as List<dynamic>?)
          ?.map((e) => TokenQuotesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'decimals': instance.decimals,
      'address': instance.address,
      'logoUrl': instance.logoUrl,
      'quotes': instance.quotes?.map((e) => e.toJson()).toList(),
    };
