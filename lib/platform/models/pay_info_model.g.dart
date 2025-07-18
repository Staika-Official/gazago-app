// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInfoModel _$PayInfoModelFromJson(Map<String, dynamic> json) => PayInfoModel(
      recipient: (json['recipient'] as num?)?.toInt(),
      amount: json['amount'] == null
          ? null
          : RequestAmountModel.fromJson(json['amount'] as Map<String, dynamic>),
      fee: json['fee'] == null
          ? null
          : RequestAmountModel.fromJson(json['fee'] as Map<String, dynamic>),
      label: json['label'] as String?,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$PayInfoModelToJson(PayInfoModel instance) =>
    <String, dynamic>{
      'recipient': instance.recipient,
      'amount': instance.amount?.toJson(),
      'fee': instance.fee?.toJson(),
      'label': instance.label,
      'memo': instance.memo,
    };
