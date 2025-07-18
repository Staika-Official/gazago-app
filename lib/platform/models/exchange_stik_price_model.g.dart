// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_stik_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeStikPriceModel _$ExchangeStikPriceModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeStikPriceModel(
      fromTokenSymbol: json['fromTokenSymbol'] as String?,
      fromUiAmountString: json['fromUiAmountString'] as String?,
      toTokenSymbol: json['toTokenSymbol'] as String?,
      toUiAmountString: json['toUiAmountString'] as String?,
      uiFeeString: json['uiFeeString'] as String?,
      feeRate: (json['feeRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExchangeStikPriceModelToJson(
        ExchangeStikPriceModel instance) =>
    <String, dynamic>{
      'fromTokenSymbol': instance.fromTokenSymbol,
      'fromUiAmountString': instance.fromUiAmountString,
      'toTokenSymbol': instance.toTokenSymbol,
      'toUiAmountString': instance.toUiAmountString,
      'uiFeeString': instance.uiFeeString,
      'feeRate': instance.feeRate,
    };
