// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayResultModel _$PayResultModelFromJson(Map<String, dynamic> json) =>
    PayResultModel(
      payed: json['payed'] == null
          ? null
          : AssetAmountModel.fromJson(json['payed'] as Map<String, dynamic>),
      fee: json['fee'] == null
          ? null
          : AssetAmountModel.fromJson(json['fee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayResultModelToJson(PayResultModel instance) =>
    <String, dynamic>{
      'payed': instance.payed?.toJson(),
      'fee': instance.fee?.toJson(),
    };
