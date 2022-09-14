import 'package:json_annotation/json_annotation.dart';

part 'asset_item_nft_model.g.dart';

@JsonSerializable()
class AssetItemNftModel {
  String name;
  double balance;
  String tokenImageUrl;

  AssetItemNftModel({
    required this.name,
    required this.balance,
    required this.tokenImageUrl,
  });

  factory AssetItemNftModel.fromJson(Map<String, dynamic> json) => _$AssetItemNftModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemNftModelToJson(this);
}
