import 'package:json_annotation/json_annotation.dart';

part 'on_chain_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OnChainWalletModel {
  int id;
  String publicKey;
  String secretKey;
  String explorerUrl;

  OnChainWalletModel({
    required this.id,
    required this.publicKey,
    required this.secretKey,
    required this.explorerUrl,
  });

  factory OnChainWalletModel.fromJson(Map<String, dynamic> json) => _$OnChainWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnChainWalletModelToJson(this);
}
