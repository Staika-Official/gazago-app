import 'package:json_annotation/json_annotation.dart';

part 'asset_amount_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetAmountModel {
  String? mint;
  String? symbol;
  int? decimals;
  double? amount;
  String? uiAmountString;

  AssetAmountModel({
    this.mint,
    this.symbol,
    this.decimals,
    this.amount,
    this.uiAmountString,
  });

  factory AssetAmountModel.fromJson(Map<String, dynamic> json) => _$AssetAmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetAmountModelToJson(this);
}
