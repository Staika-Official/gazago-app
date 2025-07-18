import 'package:json_annotation/json_annotation.dart';

part 'token_quotes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenQuotesModel {
  String? currency;
  double? price;
  String? lastUpdated;

  TokenQuotesModel({
    this.currency,
    this.price,
    this.lastUpdated,
  });

  factory TokenQuotesModel.fromJson(Map<String, dynamic> json) => _$TokenQuotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenQuotesModelToJson(this);
}
