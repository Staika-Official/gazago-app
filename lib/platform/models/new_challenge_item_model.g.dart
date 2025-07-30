// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_challenge_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewChallengeItemModel _$NewChallengeItemModelFromJson(
        Map<String, dynamic> json) =>
    NewChallengeItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      itemImageUrl: json['itemImageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      tradeSymbol: json['tradeSymbol'] as String,
      itemLabel: json['itemLabel'] as String?,
    );

Map<String, dynamic> _$NewChallengeItemModelToJson(
        NewChallengeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'itemImageUrl': instance.itemImageUrl,
      'price': instance.price,
      'tradeSymbol': instance.tradeSymbol,
      'itemLabel': instance.itemLabel,
    };
