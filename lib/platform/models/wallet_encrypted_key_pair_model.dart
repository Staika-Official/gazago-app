import 'package:json_annotation/json_annotation.dart';

part 'wallet_encrypted_key_pair_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletEncryptedKeyPairModel {
  String publicKey;
  String encryptedSecretKey;

  WalletEncryptedKeyPairModel({
    required this.publicKey,
    required this.encryptedSecretKey,
  });

  factory WalletEncryptedKeyPairModel.fromJson(Map<String, dynamic> json) => _$WalletEncryptedKeyPairModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletEncryptedKeyPairModelToJson(this);
}
