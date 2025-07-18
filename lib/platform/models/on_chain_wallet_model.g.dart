// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_chain_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnChainWalletModel _$OnChainWalletModelFromJson(Map<String, dynamic> json) =>
    OnChainWalletModel(
      id: (json['id'] as num).toInt(),
      publicKey: json['publicKey'] as String,
      secretKey: json['secretKey'] as String,
      explorerUrl: json['explorerUrl'] as String,
    );

Map<String, dynamic> _$OnChainWalletModelToJson(OnChainWalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicKey': instance.publicKey,
      'secretKey': instance.secretKey,
      'explorerUrl': instance.explorerUrl,
    };
