// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAmountModel _$AssetAmountModelFromJson(Map<String, dynamic> json) =>
    AssetAmountModel(
      mint: json['mint'] as String?,
      symbol: json['symbol'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      uiAmountString: json['uiAmountString'] as String?,
    );

Map<String, dynamic> _$AssetAmountModelToJson(AssetAmountModel instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'amount': instance.amount,
      'uiAmountString': instance.uiAmountString,
    };
