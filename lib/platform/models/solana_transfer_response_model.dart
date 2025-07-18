import 'package:json_annotation/json_annotation.dart';

part 'solana_transfer_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaTransferResponseModel {
  String? signature;
  String? solscanUrl;

  SolanaTransferResponseModel({
    this.signature,
    this.solscanUrl,
  });

  factory SolanaTransferResponseModel.fromJson(Map<String, dynamic> json) => _$SolanaTransferResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SolanaTransferResponseModelToJson(this);
}
