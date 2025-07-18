// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_solana_transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletSolanaTransferModel _$WalletSolanaTransferModelFromJson(
        Map<String, dynamic> json) =>
    WalletSolanaTransferModel(
      signature: json['signature'] as String,
      solscanUrl: json['solscanUrl'] as String,
    );

Map<String, dynamic> _$WalletSolanaTransferModelToJson(
        WalletSolanaTransferModel instance) =>
    <String, dynamic>{
      'signature': instance.signature,
      'solscanUrl': instance.solscanUrl,
    };
