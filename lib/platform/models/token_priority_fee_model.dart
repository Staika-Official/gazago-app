import 'package:json_annotation/json_annotation.dart';

part 'token_priority_fee_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenPriorityFeeModel {
  int avgFee;
  int priorityFee;

  TokenPriorityFeeModel({
    required this.avgFee,
    required this.priorityFee,
  });

  factory TokenPriorityFeeModel.fromJson(Map<String, dynamic> json) => _$TokenPriorityFeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPriorityFeeModelToJson(this);
}
