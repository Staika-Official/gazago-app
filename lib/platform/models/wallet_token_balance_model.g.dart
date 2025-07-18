// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_token_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTokenBalanceModel _$WalletTokenBalanceModelFromJson(
        Map<String, dynamic> json) =>
    WalletTokenBalanceModel(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      logoUrl: json['logoUrl'] as String,
      amount: (json['amount'] as num).toInt(),
      decimals: (json['decimals'] as num).toInt(),
      uiAmountString: json['uiAmountString'] as String,
    );

Map<String, dynamic> _$WalletTokenBalanceModelToJson(
        WalletTokenBalanceModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'amount': instance.amount,
      'decimals': instance.decimals,
      'uiAmountString': instance.uiAmountString,
    };
