import 'package:json_annotation/json_annotation.dart';

part 'asset_short_amount_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetShortAmountModel {
  String? mint;
  double? amount;

  AssetShortAmountModel({
    this.mint,
    this.amount,
  });

  factory AssetShortAmountModel.fromJson(Map<String, dynamic> json) => _$AssetShortAmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetShortAmountModelToJson(this);
}
