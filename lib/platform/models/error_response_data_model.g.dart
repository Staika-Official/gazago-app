// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponseDataModel _$ErrorResponseDataModelFromJson(
        Map<String, dynamic> json) =>
    ErrorResponseDataModel(
      status: (json['status'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
    );

Map<String, dynamic> _$ErrorResponseDataModelToJson(
        ErrorResponseDataModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errorMessage': instance.errorMessage,
      'errorCode': instance.errorCode,
    };
