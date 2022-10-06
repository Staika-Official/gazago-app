import 'package:gaza_go/platform/models/asset_amount_model.dart';
import 'package:gaza_go/platform/models/pay_result_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pay_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayResponseModel {
  String? signature;
  PayResultModel? result; //TODO. Json key 활용할것

  PayResponseModel({
    this.signature,
    this.result,
  });

  factory PayResponseModel.fromJson(Map<String, dynamic> json) => _$PayResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayResponseModelToJson(this);
}
