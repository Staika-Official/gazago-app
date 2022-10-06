import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buy_tik_result_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BuyTikResultModel {
  double? tikUiAmount;
  AssetAmountModel? payed;

  BuyTikResultModel({
    this.tikUiAmount,
    this.payed,
  });

  factory BuyTikResultModel.fromJson(Map<String, dynamic> json) => _$BuyTikResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyTikResultModelToJson(this);
}
