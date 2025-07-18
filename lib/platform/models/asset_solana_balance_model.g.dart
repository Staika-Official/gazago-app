// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_solana_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetSolanaBalanceModel _$AssetSolanaBalanceModelFromJson(
        Map<String, dynamic> json) =>
    AssetSolanaBalanceModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      uiAmount: (json['uiAmount'] as num).toDouble(),
      logoUrl: json['logoUrl'] as String,
    );

Map<String, dynamic> _$AssetSolanaBalanceModelToJson(
        AssetSolanaBalanceModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'amount': instance.amount,
      'uiAmount': instance.uiAmount,
      'logoUrl': instance.logoUrl,
    };
