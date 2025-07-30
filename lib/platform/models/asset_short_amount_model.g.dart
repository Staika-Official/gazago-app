// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_short_amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetShortAmountModel _$AssetShortAmountModelFromJson(
        Map<String, dynamic> json) =>
    AssetShortAmountModel(
      mint: json['mint'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AssetShortAmountModelToJson(
        AssetShortAmountModel instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'amount': instance.amount,
    };
