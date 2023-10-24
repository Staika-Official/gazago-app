import 'package:json_annotation/json_annotation.dart';

part 'stik_quotes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StikQuotesModel {
  double priceUSD;
  double priceKRW;
  String lastUpdated;

  StikQuotesModel({
    required this.priceUSD,
    required this.priceKRW,
    required this.lastUpdated,
  });

  factory StikQuotesModel.fromJson(Map<String, dynamic> json) => _$StikQuotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$StikQuotesModelToJson(this);
}
