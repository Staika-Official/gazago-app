// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfoModel _$TokenInfoModelFromJson(Map<String, dynamic> json) =>
    TokenInfoModel(
      mint: json['mint'] as String,
      meta: TokenMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      price: (json['price'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, TokenPriceModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$TokenInfoModelToJson(TokenInfoModel instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'meta': instance.meta.toJson(),
      'price': instance.price.map((k, e) => MapEntry(k, e.toJson())),
    };
