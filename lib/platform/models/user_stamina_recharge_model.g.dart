// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stamina_recharge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStaminaRechargeModel _$UserStaminaRechargeModelFromJson(
        Map<String, dynamic> json) =>
    UserStaminaRechargeModel(
      type: json['type'] as String,
      stat: (json['stat'] as num).toInt(),
      feeTik: (json['feeTik'] as num).toInt(),
    );

Map<String, dynamic> _$UserStaminaRechargeModelToJson(
        UserStaminaRechargeModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'stat': instance.stat,
      'feeTik': instance.feeTik,
    };
