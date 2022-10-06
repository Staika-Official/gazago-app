import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pay_result_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayResultModel {
  AssetAmountModel? payed;
  AssetAmountModel? fee;

  PayResultModel({
    this.payed,
    this.fee,
  });

  factory PayResultModel.fromJson(Map<String, dynamic> json) => _$PayResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayResultModelToJson(this);
}
