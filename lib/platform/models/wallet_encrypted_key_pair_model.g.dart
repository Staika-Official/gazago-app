// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_encrypted_key_pair_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletEncryptedKeyPairModel _$WalletEncryptedKeyPairModelFromJson(
        Map<String, dynamic> json) =>
    WalletEncryptedKeyPairModel(
      publicKey: json['publicKey'] as String,
      encryptedSecretKey: json['encryptedSecretKey'] as String,
    );

Map<String, dynamic> _$WalletEncryptedKeyPairModelToJson(
        WalletEncryptedKeyPairModel instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'encryptedSecretKey': instance.encryptedSecretKey,
    };
