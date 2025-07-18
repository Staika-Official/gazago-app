// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_token_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTokenTransactionModel _$AssetTokenTransactionModelFromJson(
        Map<String, dynamic> json) =>
    AssetTokenTransactionModel(
      transactionId: (json['transactionId'] as num?)?.toInt(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      symbol: json['symbol'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      uiAmountString: json['uiAmountString'] as String?,
      memo: json['memo'] as String?,
      createdDate: json['createdDate'] as String?,
    );

Map<String, dynamic> _$AssetTokenTransactionModelToJson(
        AssetTokenTransactionModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'amount': instance.amount,
      'uiAmountString': instance.uiAmountString,
      'memo': instance.memo,
      'createdDate': instance.createdDate,
    };
