import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solana_fee_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaFeeResponseModel {
  AssetAmountModel? fee;
  AssetAmountModel? createAccountFee;

  SolanaFeeResponseModel({
    this.fee,
    this.createAccountFee,
  });

  factory SolanaFeeResponseModel.fromJson(Map<String, dynamic> json) => _$SolanaFeeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SolanaFeeResponseModelToJson(this);
}
