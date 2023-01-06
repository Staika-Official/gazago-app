import 'package:gaza_go/platform/models/asset_token_detail_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetDetailModel {
  AssetTokenDetailBalanceModel balance;
  List<AssetTokenTransactionModel> transactions;

  AssetDetailModel({
    required this.balance,
    required this.transactions,
  });

  factory AssetDetailModel.fromJson(Map<String, dynamic> json) => _$AssetDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDetailModelToJson(this);
}
