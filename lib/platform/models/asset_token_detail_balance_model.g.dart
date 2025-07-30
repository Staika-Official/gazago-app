// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_token_detail_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTokenDetailBalanceModel _$AssetTokenDetailBalanceModelFromJson(
        Map<String, dynamic> json) =>
    AssetTokenDetailBalanceModel(
      symbol: json['symbol'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      uiAmountString: json['uiAmountString'] as String?,
    );

Map<String, dynamic> _$AssetTokenDetailBalanceModelToJson(
        AssetTokenDetailBalanceModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'amount': instance.amount,
      'uiAmountString': instance.uiAmountString,
    };
