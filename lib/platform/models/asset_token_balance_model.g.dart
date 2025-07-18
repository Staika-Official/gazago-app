// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_token_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTokenBalanceModel _$AssetTokenBalanceModelFromJson(
        Map<String, dynamic> json) =>
    AssetTokenBalanceModel(
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
      logoUrl: json['logoUrl'] as String?,
      accountId: (json['accountId'] as num?)?.toInt(),
      decimals: (json['decimals'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      uiAmountString: json['uiAmountString'] as String?,
      price: (json['price'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, TokenPriceModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AssetTokenBalanceModelToJson(
        AssetTokenBalanceModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'accountId': instance.accountId,
      'decimals': instance.decimals,
      'amount': instance.amount,
      'uiAmountString': instance.uiAmountString,
      'price': instance.price?.map((k, e) => MapEntry(k, e.toJson())),
    };
