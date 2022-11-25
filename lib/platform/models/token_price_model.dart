import 'package:json_annotation/json_annotation.dart';

part 'token_price_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenPriceModel {
  double? price;
  double? volume24h;
  double? percentChange1h;
  double? percentChange24h;
  double? percentChange7d;
  String? lastUpdated;

  TokenPriceModel({
    this.price,
    this.percentChange1h,
    this.percentChange24h,
    this.percentChange7d,
    this.lastUpdated,
  });

  factory TokenPriceModel.fromJson(Map<String, dynamic> json) => _$TokenPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPriceModelToJson(this);
}
