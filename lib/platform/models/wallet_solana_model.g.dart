// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_solana_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletSolanaModel _$WalletSolanaModelFromJson(Map<String, dynamic> json) =>
    WalletSolanaModel(
      address: json['address'] as String,
      secretkey: json['secretkey'] as String,
    );

Map<String, dynamic> _$WalletSolanaModelToJson(WalletSolanaModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'secretkey': instance.secretkey,
    };
