// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_key_pair_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletKeyPairModel _$WalletKeyPairModelFromJson(Map<String, dynamic> json) =>
    WalletKeyPairModel(
      publicKey: json['publicKey'] as String,
      secretKey: json['secretKey'] as String,
    );

Map<String, dynamic> _$WalletKeyPairModelToJson(WalletKeyPairModel instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'secretKey': instance.secretKey,
    };
