import 'package:json_annotation/json_annotation.dart';

part 'wallet_item_model.g.dart';

@JsonSerializable()
class WalletItemModel {
  String name;
  double balance;
  String tokenImageUrl;

  WalletItemModel({
    required this.name,
    required this.balance,
    required this.tokenImageUrl,
  });

  factory WalletItemModel.fromJson(Map<String, dynamic> json) => _$WalletItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletItemModelToJson(this);
}
