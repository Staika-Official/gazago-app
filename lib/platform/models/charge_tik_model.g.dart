// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_tik_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargeTikModel _$ChargeTikModelFromJson(Map<String, dynamic> json) =>
    ChargeTikModel(
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      fromTokenSymbol: json['fromTokenSymbol'] as String,
      fromUiAmount: (json['fromUiAmount'] as num).toDouble(),
      toTokenSymbol: json['toTokenSymbol'] as String,
      toUiAmount: json['toUiAmount'],
      feeTokenSymbol: json['feeTokenSymbol'] as String?,
      priceKRW: (json['priceKRW'] as num).toDouble(),
      priceUSD: (json['priceUSD'] as num).toDouble(),
      feeUiAmount: (json['feeUiAmount'] as num).toInt(),
      lastUpdatedDate: json['lastUpdatedDate'] as String,
    );

Map<String, dynamic> _$ChargeTikModelToJson(ChargeTikModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'fromTokenSymbol': instance.fromTokenSymbol,
      'fromUiAmount': instance.fromUiAmount,
      'toTokenSymbol': instance.toTokenSymbol,
      'feeTokenSymbol': instance.feeTokenSymbol,
      'toUiAmount': instance.toUiAmount,
      'priceKRW': instance.priceKRW,
      'priceUSD': instance.priceUSD,
      'feeUiAmount': instance.feeUiAmount,
      'lastUpdatedDate': instance.lastUpdatedDate,
    };
