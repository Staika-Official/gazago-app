// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creators_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Creators _$CreatorsFromJson(Map<String, dynamic> json) => Creators(
      address: json['address'] as String?,
      verified: json['verified'] as bool?,
      share: (json['share'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreatorsToJson(Creators instance) => <String, dynamic>{
      'address': instance.address,
      'verified': instance.verified,
      'share': instance.share,
    };
