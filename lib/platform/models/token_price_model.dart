import 'package:json_annotation/json_annotation.dart';

part 'token_price_model.g.dart';

@JsonSerializable()
class TokenPriceModel {
  String currency;
  double price;
  double volume24h;
  double volumeChange24h;
  double percentChange1h;
  double percentChange24h;
  double percentChange7d;
  double marketCap;
  double marketCapDominance;
  double fullyDilutedMarketCap;
  String lastUpdated;

  TokenPriceModel({
    required this.currency,
    required this.price,
    required this.volume24h,
    required this.volumeChange24h,
    required this.percentChange1h,
    required this.percentChange24h,
    required this.percentChange7d,
    required this.marketCap,
    required this.marketCapDominance,
    required this.fullyDilutedMarketCap,
    required this.lastUpdated,
  });

  factory TokenPriceModel.fromJson(Map<String, dynamic> json) => _$TokenPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPriceModelToJson(this);
}
