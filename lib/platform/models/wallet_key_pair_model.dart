import 'package:json_annotation/json_annotation.dart';

part 'wallet_key_pair_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletKeyPairModel {
  String publicKey;
  String secretKey;

  WalletKeyPairModel({
    required this.publicKey,
    required this.secretKey,
  });

  factory WalletKeyPairModel.fromJson(Map<String, dynamic> json) => _$WalletKeyPairModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletKeyPairModelToJson(this);
}
