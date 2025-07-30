// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_watch_available_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdWatchAvailableModel _$AdWatchAvailableModelFromJson(
        Map<String, dynamic> json) =>
    AdWatchAvailableModel(
      watchAvailable: json['watchAvailable'] as bool?,
      latestWatchTime: json['latestWatchTime'] as String?,
    );

Map<String, dynamic> _$AdWatchAvailableModelToJson(
        AdWatchAvailableModel instance) =>
    <String, dynamic>{
      'watchAvailable': instance.watchAvailable,
      'latestWatchTime': instance.latestWatchTime,
    };
