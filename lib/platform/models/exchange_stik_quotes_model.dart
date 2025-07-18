import 'package:json_annotation/json_annotation.dart';

part 'exchange_stik_quotes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeStikQuotesModel {
  double? priceKRW;
  double? priceUSD;
  String? lastUpdated;

  ExchangeStikQuotesModel({
    this.priceKRW,
    this.priceUSD,
    this.lastUpdated,
  });

  factory ExchangeStikQuotesModel.fromJson(Map<String, dynamic> json) => _$ExchangeStikQuotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStikQuotesModelToJson(this);
}
