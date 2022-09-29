import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_model.g.dart';

@JsonSerializable()
class AssetTokenBalanceModel {
  String? publicKey;
  String? mint;
  int? decimals;
  double? amount;
  String? uiAmountString;

  AssetTokenBalanceModel({
    this.publicKey,
    this.mint,
    this.decimals,
    this.amount,
    this.uiAmountString,
  });

  factory AssetTokenBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceModelToJson(this);
}
