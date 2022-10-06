import 'package:gaza_go/platform/models/buy_tik_result_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buy_tik_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BuyTikResponseModel {
  String? signature;
  BuyTikResultModel? result;

  BuyTikResponseModel({
    this.signature,
    this.result,
  });

  factory BuyTikResponseModel.fromJson(Map<String, dynamic> json) => _$BuyTikResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyTikResponseModelToJson(this);
}
