import 'package:json_annotation/json_annotation.dart';

part 'transfer_nft_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransferNftRequestModel {
  String tokenAddress;
  String encodedTransaction;

  TransferNftRequestModel({
    required this.tokenAddress,
    required this.encodedTransaction,
  });

  factory TransferNftRequestModel.fromJson(Map<String, dynamic> json) => _$TransferNftRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransferNftRequestModelToJson(this);
}
