// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_challenge_user_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewChallengeUserItemModel _$NewChallengeUserItemModelFromJson(
        Map<String, dynamic> json) =>
    NewChallengeUserItemModel(
      id: (json['id'] as num).toInt(),
      equipped: json['equipped'] as bool,
    );

Map<String, dynamic> _$NewChallengeUserItemModelToJson(
        NewChallengeUserItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equipped': instance.equipped,
    };
