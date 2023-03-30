import 'package:json_annotation/json_annotation.dart';

part 'stik_token_quotes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StikTokenQuotesModel {
  String? currency;
  double? price;
  String? lastUpdated;

  StikTokenQuotesModel({
    this.currency,
    this.price,
    this.lastUpdated,
  });

  factory StikTokenQuotesModel.fromJson(Map<String, dynamic> json) => _$StikTokenQuotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$StikTokenQuotesModelToJson(this);
}
