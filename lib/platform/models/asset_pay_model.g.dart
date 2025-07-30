// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_pay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetPayModel _$AssetPayModelFromJson(Map<String, dynamic> json) =>
    AssetPayModel(
      recipient: (json['recipient'] as num?)?.toInt(),
      amount: AssetPayModel.fromJson(json['amount'] as Map<String, dynamic>),
      fee: AssetPayModel.fromJson(json['fee'] as Map<String, dynamic>),
      label: json['label'] as String,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$AssetPayModelToJson(AssetPayModel instance) =>
    <String, dynamic>{
      'recipient': instance.recipient,
      'amount': instance.amount.toJson(),
      'fee': instance.fee.toJson(),
      'label': instance.label,
      'memo': instance.memo,
    };
