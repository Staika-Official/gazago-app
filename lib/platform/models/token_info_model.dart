import 'package:gaza_go/platform/models/token_price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenInfoModel {
  String symbol;
  String name;
  String logoUrl;
  Map<String, TokenPriceModel>? price;

  TokenInfoModel({
    required this.symbol,
    required this.name,
    required this.logoUrl,
    required this.price,
  });

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoModelToJson(this);
}
