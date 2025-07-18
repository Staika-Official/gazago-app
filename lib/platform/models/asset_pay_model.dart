import 'package:json_annotation/json_annotation.dart';

part 'asset_pay_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetPayModel {
  int? recipient;
  AssetPayModel amount;
  AssetPayModel fee;
  String label; // enum PaymentPurpose.label
  String? memo;

  AssetPayModel({
    this.recipient,
    required this.amount,
    required this.fee,
    required this.label,
    this.memo,
  });

  factory AssetPayModel.fromJson(Map<String, dynamic> json) => _$AssetPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetPayModelToJson(this);
}
