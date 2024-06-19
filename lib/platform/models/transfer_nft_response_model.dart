import 'package:json_annotation/json_annotation.dart';

part 'transfer_nft_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransferNftResponseModel {
  String signature;

  TransferNftResponseModel({
    required this.signature,
  });

  factory TransferNftResponseModel.fromJson(Map<String, dynamic> json) => _$TransferNftResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransferNftResponseModelToJson(this);
}
