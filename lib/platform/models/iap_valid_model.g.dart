// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_valid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IapValidModel _$IapValidModelFromJson(Map<String, dynamic> json) =>
    IapValidModel(
      valid: json['valid'] as bool,
      state: json['state'] as String,
    );

Map<String, dynamic> _$IapValidModelToJson(IapValidModel instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'state': instance.state,
    };
