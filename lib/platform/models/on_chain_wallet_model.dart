import 'package:json_annotation/json_annotation.dart';

part 'on_chain_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OnChainWalletModel {
  int id;
  String? publicKey;
  String secretKey;

  OnChainWalletModel({
    required this.id,
    this.publicKey,
    required this.secretKey,
  });

  factory OnChainWalletModel.fromJson(Map<String, dynamic> json) => _$OnChainWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnChainWalletModelToJson(this);
}
