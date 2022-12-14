import 'package:json_annotation/json_annotation.dart';

part 'asset_token_detail_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenDetailBalanceModel {
  String? symbol;
  int? decimals;
  double? amount;
  String? uiAmountString;

  AssetTokenDetailBalanceModel({
    this.symbol,
    this.decimals,
    this.amount,
    this.uiAmountString,
  });

  factory AssetTokenDetailBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetTokenDetailBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenDetailBalanceModelToJson(this);
}
