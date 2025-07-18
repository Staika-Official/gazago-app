import 'package:json_annotation/json_annotation.dart';

part 'exchange_token_withdrawal_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeTokenWithdrawalModel {
  String type;
  double uiAmount;
  double fee;
  String encodedTransaction;

  ExchangeTokenWithdrawalModel({
    required this.type,
    required this.uiAmount,
    required this.fee,
    required this.encodedTransaction,
  });

  factory ExchangeTokenWithdrawalModel.fromJson(Map<String, dynamic> json) => _$ExchangeTokenWithdrawalModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeTokenWithdrawalModelToJson(this);
}
