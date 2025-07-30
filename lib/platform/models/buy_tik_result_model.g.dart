// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_tik_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyTikResultModel _$BuyTikResultModelFromJson(Map<String, dynamic> json) =>
    BuyTikResultModel(
      tikUiAmount: (json['tikUiAmount'] as num?)?.toDouble(),
      payed: json['payed'] == null
          ? null
          : AssetAmountModel.fromJson(json['payed'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuyTikResultModelToJson(BuyTikResultModel instance) =>
    <String, dynamic>{
      'tikUiAmount': instance.tikUiAmount,
      'payed': instance.payed?.toJson(),
    };
