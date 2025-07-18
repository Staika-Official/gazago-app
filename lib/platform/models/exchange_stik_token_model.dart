import 'package:gaza_go/platform/models/exchange_stik_price_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_quotes_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_stik_token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeStikTokenModel {
  ExchangeStikQuotesModel? quotes;
  List<ExchangeStikPriceModel> products;

  ExchangeStikTokenModel({
    this.quotes,
    required this.products,
  });

  factory ExchangeStikTokenModel.fromJson(Map<String, dynamic> json) => _$ExchangeStikTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStikTokenModelToJson(this);
}
