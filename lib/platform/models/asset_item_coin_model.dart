import 'package:json_annotation/json_annotation.dart';

part 'asset_item_coin_model.g.dart';

@JsonSerializable()
class AssetItemCoinModel {
  String name;
  double balance;
  String tokenImageUrl;

  AssetItemCoinModel({
    required this.name,
    required this.balance,
    required this.tokenImageUrl,
  });

  factory AssetItemCoinModel.fromJson(Map<String, dynamic> json) => _$AssetItemCoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemCoinModelToJson(this);
}
