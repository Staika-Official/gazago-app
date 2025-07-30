// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestAmountModel _$RequestAmountModelFromJson(Map<String, dynamic> json) =>
    RequestAmountModel(
      symbol: json['symbol'] as String?,
      uiAmount: (json['uiAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RequestAmountModelToJson(RequestAmountModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'uiAmount': instance.uiAmount,
    };
