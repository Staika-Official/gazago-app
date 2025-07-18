// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_token_withdrawal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeTokenWithdrawalModel _$ExchangeTokenWithdrawalModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeTokenWithdrawalModel(
      type: json['type'] as String,
      uiAmount: (json['uiAmount'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      encodedTransaction: json['encodedTransaction'] as String,
    );

Map<String, dynamic> _$ExchangeTokenWithdrawalModelToJson(
        ExchangeTokenWithdrawalModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'uiAmount': instance.uiAmount,
      'fee': instance.fee,
      'encodedTransaction': instance.encodedTransaction,
    };
