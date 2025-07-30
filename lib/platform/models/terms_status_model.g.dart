// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsStatusModel _$TermsStatusModelFromJson(Map<String, dynamic> json) =>
    TermsStatusModel(
      activated: json['activated'] as bool,
      boardType: json['boardType'] as String,
      createdDate: json['createdDate'] as String?,
    );

Map<String, dynamic> _$TermsStatusModelToJson(TermsStatusModel instance) =>
    <String, dynamic>{
      'activated': instance.activated,
      'boardType': instance.boardType,
      'createdDate': instance.createdDate,
    };
