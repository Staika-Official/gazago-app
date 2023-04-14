import 'package:json_annotation/json_annotation.dart';

part 'asset_solana_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetSolanaBalanceModel {
  String symbol;
  String name;
  double amount;
  double uiAmount;
  String logoUrl;

  AssetSolanaBalanceModel({
    required this.symbol,
    required this.name,
    required this.amount,
    required this.uiAmount,
    required this.logoUrl,
  });

  factory AssetSolanaBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetSolanaBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetSolanaBalanceModelToJson(this);
}
