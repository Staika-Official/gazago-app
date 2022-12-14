import 'package:gaza_go/platform/models/asset_address_model.dart';
import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:gaza_go/platform/models/asset_short_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenTransactionModel {
  int? transactionId;
  String? type;
  String? title;
  String? content;
  String? symbol;
  int? decimals;
  double? amount;
  String? uiAmountString;
  String? memo;
  String? createdDate;

  AssetTokenTransactionModel({
    this.transactionId,
    this.type,
    this.title,
    this.content,
    this.symbol,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.memo,
    this.createdDate,
  });

  factory AssetTokenTransactionModel.fromJson(Map<String, dynamic> json) => _$AssetTokenTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenTransactionModelToJson(this);
}
