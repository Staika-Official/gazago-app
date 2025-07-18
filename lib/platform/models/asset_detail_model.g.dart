// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDetailModel _$AssetDetailModelFromJson(Map<String, dynamic> json) =>
    AssetDetailModel(
      balance: AssetTokenDetailBalanceModel.fromJson(
          json['balance'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) =>
              AssetTokenTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetDetailModelToJson(AssetDetailModel instance) =>
    <String, dynamic>{
      'balance': instance.balance.toJson(),
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
    };
