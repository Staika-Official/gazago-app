import 'package:json_annotation/json_annotation.dart';

part 'exchange_stik_price_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeStikPriceModel {
  String? fromTokenSymbol;
  String? fromUiAmountString;
  String? toTokenSymbol;
  String? toUiAmountString;

  ExchangeStikPriceModel({
    this.fromTokenSymbol,
    this.fromUiAmountString,
    this.toTokenSymbol,
    this.toUiAmountString,
  });

  factory ExchangeStikPriceModel.fromJson(Map<String, dynamic> json) => _$ExchangeStikPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStikPriceModelToJson(this);
}
