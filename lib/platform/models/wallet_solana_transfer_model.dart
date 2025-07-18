import 'package:json_annotation/json_annotation.dart';

part 'wallet_solana_transfer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletSolanaTransferModel {
  String signature;
  String solscanUrl;

  WalletSolanaTransferModel({
    required this.signature,
    required this.solscanUrl,
  });

  factory WalletSolanaTransferModel.fromJson(Map<String, dynamic> json) => _$WalletSolanaTransferModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSolanaTransferModelToJson(this);
}
