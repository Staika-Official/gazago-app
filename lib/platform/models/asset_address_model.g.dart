// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAddressModel _$AssetAddressModelFromJson(Map<String, dynamic> json) =>
    AssetAddressModel(
      publicKey: json['publicKey'] as String,
      owner: json['owner'] as String,
    );

Map<String, dynamic> _$AssetAddressModelToJson(AssetAddressModel instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'owner': instance.owner,
    };
