import 'package:gaza_go/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_token_balance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletTokenBalanceModel {
  String symbol;
  String name;
  String logoUrl;
  int amount;
  int decimals;
  String uiAmountString;

  WalletTokenBalanceModel({
    required this.name,
    required this.symbol,
    required this.logoUrl,
    required this.amount,
    required this.decimals,
    required this.uiAmountString,
  });

  factory WalletTokenBalanceModel.fromJson(Map<String, dynamic> json) => _$WalletTokenBalanceModelFromJson(json);

  set currency(Currency currency) {}

  Map<String, dynamic> toJson() => _$WalletTokenBalanceModelToJson(this);
}
