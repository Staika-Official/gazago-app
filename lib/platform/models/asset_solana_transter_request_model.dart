import 'package:gaza_go/platform/models/request_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_solana_transter_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetSolanaTransferRequestModel {
  String? source;
  String? destination;
  RequestAmountModel? amount;
  String? secretKey;

  AssetSolanaTransferRequestModel({
    this.source,
    this.destination,
    this.amount,
    this.secretKey,
  });

  factory AssetSolanaTransferRequestModel.fromJson(Map<String, dynamic> json) => _$AssetSolanaTransferRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetSolanaTransferRequestModelToJson(this);
}
