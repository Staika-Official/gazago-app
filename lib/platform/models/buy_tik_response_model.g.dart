// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_tik_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyTikResponseModel _$BuyTikResponseModelFromJson(Map<String, dynamic> json) =>
    BuyTikResponseModel(
      signature: json['signature'] as String?,
      result: json['result'] == null
          ? null
          : BuyTikResultModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuyTikResponseModelToJson(
        BuyTikResponseModel instance) =>
    <String, dynamic>{
      'signature': instance.signature,
      'result': instance.result?.toJson(),
    };
