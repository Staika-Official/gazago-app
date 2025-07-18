import 'package:json_annotation/json_annotation.dart';

part 'wallet_solana_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletSolanaModel {
  String address;
  String secretkey;

  WalletSolanaModel({
    required this.address,
    required this.secretkey,
  });

  factory WalletSolanaModel.fromJson(Map<String, dynamic> json) => _$WalletSolanaModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSolanaModelToJson(this);
}
