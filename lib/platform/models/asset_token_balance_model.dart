import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenBalanceModel {
  int? accountId;
  String? symbol;
  int? decimals;
  double? amount;
  String? uiAmountString;

  AssetTokenBalanceModel({
    this.accountId,
    this.symbol,
    this.decimals,
    this.amount,
    this.uiAmountString,
  });

  factory AssetTokenBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceModelToJson(this);
}
