import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'iap_pay_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IapPayModel {
  bool payed;

  IapPayModel({
    required this.payed
  });

  factory IapPayModel.fromJson(Map<String, dynamic> json) => _$IapPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$IapPayModelToJson(this);
}
