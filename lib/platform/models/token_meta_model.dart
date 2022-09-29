import 'package:json_annotation/json_annotation.dart';

part 'token_meta_model.g.dart';

@JsonSerializable()
class TokenMetaModel {
  String symbol;
  String name;
  String logoUrl;

  TokenMetaModel({
    required this.symbol,
    required this.name,
    required this.logoUrl,
  });

  factory TokenMetaModel.fromJson(Map<String, dynamic> json) => _$TokenMetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenMetaModelToJson(this);
}
