import 'package:gaza_go/platform/models/asset_address_model.dart';
import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:gaza_go/platform/models/asset_short_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetTokenTransactionModel {
  String? signature;
  String? timestamp;
  String? confirmationStatus; //enum TransactionConfirmationStatus
  String? err;
  String? solscanUrl;
  AssetAddressModel? source;
  AssetAddressModel? destination;
  List<String>? type; // enum TransactionType.label
  String? description;
  String? mint;
  int? decimals;
  double? amount;
  String? uiAmountString;
  AssetShortAmountModel? preBalance;
  AssetShortAmountModel? postBalance;
  AssetAmountModel? fee;

  AssetTokenTransactionModel({
    this.signature,
    this.timestamp,
    this.confirmationStatus,
    this.err,
    this.solscanUrl,
    this.source,
    this.destination,
    this.type,
    this.description,
    this.mint,
    this.decimals,
    this.amount,
    this.uiAmountString,
    this.preBalance,
    this.postBalance,
    this.fee,
  });

  factory AssetTokenTransactionModel.fromJson(Map<String, dynamic> json) => _$AssetTokenTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenTransactionModelToJson(this);
}
