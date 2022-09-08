// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankerModel _$RankerModelFromJson(Map<String, dynamic> json) => RankerModel(
      place: json['place'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      goBalance: (json['goBalance'] as num).toDouble(),
      tikBalance: (json['tikBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$RankerModelToJson(RankerModel instance) =>
    <String, dynamic>{
      'place': instance.place,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'goBalance': instance.goBalance,
      'tikBalance': instance.tikBalance,
    };
