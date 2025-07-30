// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_items_summaries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserItemsSummariesModel _$UserItemsSummariesModelFromJson(
        Map<String, dynamic> json) =>
    UserItemsSummariesModel(
      id: (json['id'] as num).toInt(),
      itemId: (json['itemId'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      equipped: json['equipped'] as bool,
    );

Map<String, dynamic> _$UserItemsSummariesModelToJson(
        UserItemsSummariesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'amount': instance.amount,
      'equipped': instance.equipped,
    };
