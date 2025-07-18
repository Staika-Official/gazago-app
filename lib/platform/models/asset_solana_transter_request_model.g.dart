// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_solana_transter_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetSolanaTransferRequestModel _$AssetSolanaTransferRequestModelFromJson(
        Map<String, dynamic> json) =>
    AssetSolanaTransferRequestModel(
      source: json['source'] as String?,
      destination: json['destination'] as String?,
      amount: json['amount'] == null
          ? null
          : RequestAmountModel.fromJson(json['amount'] as Map<String, dynamic>),
      secretKey: json['secretKey'] as String?,
    );

Map<String, dynamic> _$AssetSolanaTransferRequestModelToJson(
        AssetSolanaTransferRequestModel instance) =>
    <String, dynamic>{
      'source': instance.source,
      'destination': instance.destination,
      'amount': instance.amount?.toJson(),
      'secretKey': instance.secretKey,
    };
