import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_solana_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetSolanaBalanceModel {
  String? publicKey;
  String? mint;
  int? decimals;
  double? amount;
  String? uiAmountString;
  List<AssetTokenBalanceModel>? tokens;
  List<AssetTokenBalanceModel>? ntfs;

  AssetSolanaBalanceModel({
    this.publicKey,
    this.mint,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.tokens,
    this.ntfs,
  });

  factory AssetSolanaBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetSolanaBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetSolanaBalanceModelToJson(this);
}
