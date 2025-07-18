import 'package:gaza_go/platform/models/token_price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenBalanceModel {
  String? symbol;
  String? name;
  String? logoUrl;
  int? accountId;
  int? decimals;
  double? amount;
  String? uiAmountString;
  Map<String, TokenPriceModel>? price;

  AssetTokenBalanceModel({
    this.symbol,
    this.name,
    this.logoUrl,
    this.accountId,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.price,
  });

  factory AssetTokenBalanceModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceModelToJson(this);
}
