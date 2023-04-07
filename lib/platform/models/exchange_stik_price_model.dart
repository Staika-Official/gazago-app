import 'package:json_annotation/json_annotation.dart';

part 'exchange_stik_price_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeStikPriceModel {
  String? fromTokenSymbol;
  double? fromUiAmount;
  String? toTokenSymbol;
  int? toUiAmount;

  ExchangeStikPriceModel({
    this.fromTokenSymbol,
    this.fromUiAmount,
    this.toTokenSymbol,
    this.toUiAmount,
  });

  factory ExchangeStikPriceModel.fromJson(Map<String, dynamic> json) => _$ExchangeStikPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStikPriceModelToJson(this);
}
