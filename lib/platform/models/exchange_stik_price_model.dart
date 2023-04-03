import 'package:json_annotation/json_annotation.dart';

part 'exchange_stik_price_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeStikPriceModel {
  String? fromSymbol;
  double? fromUiAmount;
  String? toSymbol;
  int? toUiAmount;

  ExchangeStikPriceModel({
    this.fromSymbol,
    this.fromUiAmount,
    this.toSymbol,
    this.toUiAmount,
  });

  factory ExchangeStikPriceModel.fromJson(Map<String, dynamic> json) => _$ExchangeStikPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStikPriceModelToJson(this);
}
