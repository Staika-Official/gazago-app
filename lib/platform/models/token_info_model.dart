import 'package:gaza_go/platform/models/token_price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_info_model.g.dart';

@JsonSerializable()
class TokenInfoModel {
  String mint;
  TokenInfoModel meta;
  List<TokenPriceModel> price;

  TokenInfoModel({
    required this.mint,
    required this.meta,
    required this.price,
  });

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoModelToJson(this);
}
