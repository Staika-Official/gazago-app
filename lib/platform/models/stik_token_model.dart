import 'package:gaza_go/platform/models/stik_token_quotes_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stik_token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StikTokenModel {
  String? symbol;
  String? name;
  int? decimals;
  String? address;
  String? logoUrl;
  List<StikTokenQuotesModel>? quotes;

  StikTokenModel({
    this.symbol,
    this.name,
    this.decimals,
    this.address,
    this.logoUrl,
    this.quotes,
  });

  factory StikTokenModel.fromJson(Map<String, dynamic> json) => _$StikTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$StikTokenModelToJson(this);
}
