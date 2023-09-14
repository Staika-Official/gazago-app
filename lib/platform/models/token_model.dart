import 'package:gaza_go/platform/models/token_quotes_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenModel {
  String? symbol;
  String? name;
  int? decimals;
  String? address;
  String? logoUrl;
  List<TokenQuotesModel>? quotes;

  TokenModel({
    this.symbol,
    this.name,
    this.decimals,
    this.address,
    this.logoUrl,
    this.quotes,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
