// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftDetailModel _$NftDetailModelFromJson(Map<String, dynamic> json) =>
    NftDetailModel(
      model: json['model'] as String?,
      updateAuthorityAddress: json['updateAuthorityAddress'] as String?,
      json: json['json'] == null
          ? null
          : NftMetaData.fromJson(json['json'] as Map<String, dynamic>),
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
      collection: json['collection'] == null
          ? null
          : Collection.fromJson(json['collection'] as Map<String, dynamic>),
      collectionDetails: json['collectionDetails'] == null
          ? null
          : CollectionDetails.fromJson(
              json['collectionDetails'] as Map<String, dynamic>),
      uses: json['uses'] as String?,
      programmableConfig: json['programmableConfig'] as String?,
      address: json['address'] as String?,
      metadataAddress: json['metadataAddress'] as String?,
      mint: json['mint'] == null
          ? null
          : Mint.fromJson(json['mint'] as Map<String, dynamic>),
      edition: json['edition'] == null
          ? null
          : Edition.fromJson(json['edition'] as Map<String, dynamic>),
      belongTo: json['belongTo'] as String?,
    );

Map<String, dynamic> _$NftDetailModelToJson(NftDetailModel instance) =>
    <String, dynamic>{
      'model': instance.model,
      'updateAuthorityAddress': instance.updateAuthorityAddress,
      'json': instance.json?.toJson(),
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
      'collection': instance.collection?.toJson(),
      'collectionDetails': instance.collectionDetails?.toJson(),
      'uses': instance.uses,
      'programmableConfig': instance.programmableConfig,
      'address': instance.address,
      'metadataAddress': instance.metadataAddress,
      'mint': instance.mint?.toJson(),
      'edition': instance.edition?.toJson(),
      'belongTo': instance.belongTo,
    };

Mint _$MintFromJson(Map<String, dynamic> json) => Mint(
      model: json['model'] as String?,
      address: json['address'] as String?,
      mintAuthorityAddress: json['mintAuthorityAddress'] as String?,
      freezeAuthorityAddress: json['freezeAuthorityAddress'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      supply: json['supply'] == null
          ? null
          : Supply.fromJson(json['supply'] as Map<String, dynamic>),
      isWrappedSol: json['isWrappedSol'] as bool?,
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MintToJson(Mint instance) => <String, dynamic>{
      'model': instance.model,
      'address': instance.address,
      'mintAuthorityAddress': instance.mintAuthorityAddress,
      'freezeAuthorityAddress': instance.freezeAuthorityAddress,
      'decimals': instance.decimals,
      'supply': instance.supply?.toJson(),
      'isWrappedSol': instance.isWrappedSol,
      'currency': instance.currency?.toJson(),
    };

Supply _$SupplyFromJson(Map<String, dynamic> json) => Supply(
      basisPoints: json['basisPoints'] as String?,
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupplyToJson(Supply instance) => <String, dynamic>{
      'basisPoints': instance.basisPoints,
      'currency': instance.currency?.toJson(),
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      symbol: json['symbol'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      namespace: json['namespace'] as String?,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'namespace': instance.namespace,
    };

Edition _$EditionFromJson(Map<String, dynamic> json) => Edition(
      model: json['model'] as String?,
      isOriginal: json['isOriginal'] as bool?,
      address: json['address'] as String?,
      supply: json['supply'] as String?,
      maxSupply: json['maxSupply'] as String?,
    );

Map<String, dynamic> _$EditionToJson(Edition instance) => <String, dynamic>{
      'model': instance.model,
      'isOriginal': instance.isOriginal,
      'address': instance.address,
      'supply': instance.supply,
      'maxSupply': instance.maxSupply,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      verified: json['verified'] as bool?,
      key: json['key'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'key': instance.key,
      'address': instance.address,
    };

CollectionDetails _$CollectionDetailsFromJson(Map<String, dynamic> json) =>
    CollectionDetails(
      version: json['version'] as String?,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$CollectionDetailsToJson(CollectionDetails instance) =>
    <String, dynamic>{
      'version': instance.version,
      'size': instance.size,
    };
