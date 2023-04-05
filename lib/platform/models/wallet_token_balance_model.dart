import 'package:gaza_go/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_token_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletTokenBalanceModel {
  String? symbol;
  String? name;
  String? logoUrl;
  int? amount;
  double? uiAmount;

  WalletTokenBalanceModel({
    this.name,
    this.symbol,
    this.logoUrl,
    this.amount,
    this.uiAmount,
  });

  factory WalletTokenBalanceModel.fromJson(Map<String, dynamic> json) => _$WalletTokenBalanceModelFromJson(json);

  set currency(Currency currency) {}

  Map<String, dynamic> toJson() => _$WalletTokenBalanceModelToJson(this);
}
