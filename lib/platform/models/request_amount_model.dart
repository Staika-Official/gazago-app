import 'package:json_annotation/json_annotation.dart';

part 'request_amount_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestAmountModel {
  String? symbol;
  double? uiAmount;

  RequestAmountModel({
    this.symbol,
    this.uiAmount,
  });

  factory RequestAmountModel.fromJson(Map<String, dynamic> json) => _$RequestAmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestAmountModelToJson(this);
}
