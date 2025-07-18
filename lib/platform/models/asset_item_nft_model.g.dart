// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_item_nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetItemNftModel _$AssetItemNftModelFromJson(Map<String, dynamic> json) =>
    AssetItemNftModel(
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
      tokenImageUrl: json['tokenImageUrl'] as String,
    );

Map<String, dynamic> _$AssetItemNftModelToJson(AssetItemNftModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
      'tokenImageUrl': instance.tokenImageUrl,
    };
