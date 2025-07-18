// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_stamina_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryStaminaModel _$RecoveryStaminaModelFromJson(
        Map<String, dynamic> json) =>
    RecoveryStaminaModel(
      recoveryUuid: json['recoveryUuid'] as String,
      recoveryItems: (json['recoveryItems'] as List<dynamic>)
          .map((e) => RepairUseItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecoveryStaminaModelToJson(
        RecoveryStaminaModel instance) =>
    <String, dynamic>{
      'recoveryUuid': instance.recoveryUuid,
      'recoveryItems': instance.recoveryItems.map((e) => e.toJson()).toList(),
    };
