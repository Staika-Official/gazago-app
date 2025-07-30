// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solana_transfer_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaTransferResponseModel _$SolanaTransferResponseModelFromJson(
        Map<String, dynamic> json) =>
    SolanaTransferResponseModel(
      signature: json['signature'] as String?,
      solscanUrl: json['solscanUrl'] as String?,
    );

Map<String, dynamic> _$SolanaTransferResponseModelToJson(
        SolanaTransferResponseModel instance) =>
    <String, dynamic>{
      'signature': instance.signature,
      'solscanUrl': instance.solscanUrl,
    };
