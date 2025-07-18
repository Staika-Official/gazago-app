// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayResponseModel _$PayResponseModelFromJson(Map<String, dynamic> json) =>
    PayResponseModel(
      signature: json['signature'] as String?,
      result: json['result'] == null
          ? null
          : PayResultModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayResponseModelToJson(PayResponseModel instance) =>
    <String, dynamic>{
      'signature': instance.signature,
      'result': instance.result?.toJson(),
    };
