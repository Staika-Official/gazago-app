// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftModel _$NftModelFromJson(Map<String, dynamic> json) => NftModel(
      model: json['model'] as String?,
      address: json['address'] as String?,
      mintAddress: json['mintAddress'] as String?,
      updateAuthorityAddress: json['updateAuthorityAddress'] as String?,
      jsonLoaded: json['jsonLoaded'] as bool?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      uri: json['uri'] as String?,
      isMutable: json['isMutable'] as bool?,
      primarySaleHappened: json['primarySaleHappened'] as bool?,
      sellerFeeBasisPoints: (json['sellerFeeBasisPoints'] as num?)?.toInt(),
      editionNonce: (json['editionNonce'] as num?)?.toInt(),
      creators: (json['creators'] as List<dynamic>?)
          ?.map((e) => Creators.fromJson(e as Map<String, dynamic>))
          .toList(),
      tokenStandard: (json['tokenStandard'] as num?)?.toInt(),
      metadata: json['metadata'] == null
          ? null
          : NftMetaData.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NftModelToJson(NftModel instance) => <String, dynamic>{
      'model': instance.model,
      'address': instance.address,
      'mintAddress': instance.mintAddress,
      'updateAuthorityAddress': instance.updateAuthorityAddress,
      'jsonLoaded': instance.jsonLoaded,
      'name': instance.name,
      'symbol': instance.symbol,
      'uri': instance.uri,
      'isMutable': instance.isMutable,
      'primarySaleHappened': instance.primarySaleHappened,
      'sellerFeeBasisPoints': instance.sellerFeeBasisPoints,
      'editionNonce': instance.editionNonce,
      'creators': instance.creators?.map((e) => e.toJson()).toList(),
      'tokenStandard': instance.tokenStandard,
      'metadata': instance.metadata?.toJson(),
    };
