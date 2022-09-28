import 'package:json_annotation/json_annotation.dart';

part 'user_stamina_recharge_model.g.dart';

@JsonSerializable()
class UserStaminaRechargeModel {
  String type;
  int stat;
  int feeTik;

  UserStaminaRechargeModel({
    required this.type,
    required this.stat,
    required this.feeTik,
  });

  factory UserStaminaRechargeModel.fromJson(Map<String, dynamic> json) => _$UserStaminaRechargeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStaminaRechargeModelToJson(this);
}
