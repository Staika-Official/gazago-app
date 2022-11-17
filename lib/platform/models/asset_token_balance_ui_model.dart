import 'package:gaza_go/platform/models/token_price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_ui_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenBalanceUiModel {
  int? accountId;
  int? decimals;
  double? amount;
  String? uiAmountString;
  String? symbol;
  String? name;
  String? logoUrl;
  Map<String, TokenPriceModel>? price;

  AssetTokenBalanceUiModel({
    this.accountId,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.symbol,
    this.name,
    this.logoUrl,
    this.price,
  });

  factory AssetTokenBalanceUiModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceUiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceUiModelToJson(this);
}
