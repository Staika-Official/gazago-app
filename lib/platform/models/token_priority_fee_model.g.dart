// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_priority_fee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPriorityFeeModel _$TokenPriorityFeeModelFromJson(
        Map<String, dynamic> json) =>
    TokenPriorityFeeModel(
      avgFee: (json['avgFee'] as num).toInt(),
      priorityFee: (json['priorityFee'] as num).toInt(),
    );

Map<String, dynamic> _$TokenPriorityFeeModelToJson(
        TokenPriorityFeeModel instance) =>
    <String, dynamic>{
      'avgFee': instance.avgFee,
      'priorityFee': instance.priorityFee,
    };
