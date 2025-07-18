// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsHistoryModel _$TermsHistoryModelFromJson(Map<String, dynamic> json) =>
    TermsHistoryModel(
      terms: json['terms'] as String,
      postId: (json['postId'] as num).toInt(),
      activated: json['activated'] as bool,
      boardType: json['boardType'] as String,
      clientId: json['clientId'] as String? ?? 'GAZAGO',
    );

Map<String, dynamic> _$TermsHistoryModelToJson(TermsHistoryModel instance) =>
    <String, dynamic>{
      'terms': instance.terms,
      'postId': instance.postId,
      'activated': instance.activated,
      'boardType': instance.boardType,
      'clientId': instance.clientId,
    };
