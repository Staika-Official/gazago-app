import 'package:gaza_go/platform/models/token_meta_model.dart';
import 'package:gaza_go/platform/models/token_price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_ui_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenBalanceUiModel {
  String? publicKey;
  String? mint;
  int? decimals;
  double? amount;
  String? uiAmountString;
  TokenMetaModel? meta;
  Map<String, TokenPriceModel>? price;

  AssetTokenBalanceUiModel({
    this.publicKey,
    this.mint,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.meta,
    this.price,
  });

  factory AssetTokenBalanceUiModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceUiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceUiModelToJson(this);
}
