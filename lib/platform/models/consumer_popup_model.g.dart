// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_popup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumerPopupModel _$ConsumerPopupModelFromJson(Map<String, dynamic> json) =>
    ConsumerPopupModel(
      type: json['type'] as String,
      currentStat: (json['currentStat'] as num).toDouble(),
      selectedStat: (json['selectedStat'] as num).toInt(),
      resultStat: (json['resultStat'] as num).toDouble(),
    );

Map<String, dynamic> _$ConsumerPopupModelToJson(ConsumerPopupModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'currentStat': instance.currentStat,
      'selectedStat': instance.selectedStat,
      'resultStat': instance.resultStat,
    };
