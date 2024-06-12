import 'package:gaza_go/platform/models/creators_model.dart';
import 'package:gaza_go/platform/models/nft_meta_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NftDetailModel {
  String? model;
  String? updateAuthorityAddress;
  NftMetaData? json;
  bool? jsonLoaded;
  String? name;
  String? symbol;
  String? uri;
  bool? isMutable;
  bool? primarySaleHappened;
  int? sellerFeeBasisPoints;
  int? editionNonce;
  List<Creators>? creators;
  int? tokenStandard;
  Collection? collection;
  CollectionDetails? collectionDetails;
  String? uses;
  String? programmableConfig;
  String? address;
  String? metadataAddress;
  Mint? mint;
  Edition? edition;
  String? belongTo;

  NftDetailModel(
      {this.model,
      this.updateAuthorityAddress,
      this.json,
      this.jsonLoaded,
      this.name,
      this.symbol,
      this.uri,
      this.isMutable,
      this.primarySaleHappened,
      this.sellerFeeBasisPoints,
      this.editionNonce,
      this.creators,
      this.tokenStandard,
      this.collection,
      this.collectionDetails,
      this.uses,
      this.programmableConfig,
      this.address,
      this.metadataAddress,
      this.mint,
      this.edition,
      this.belongTo});

  factory NftDetailModel.fromJson(Map<String, dynamic> json) => _$NftDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftDetailModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Mint {
  String? model;
  String? address;
  String? mintAuthorityAddress;
  String? freezeAuthorityAddress;
  int? decimals;
  Supply? supply;
  bool? isWrappedSol;
  Currency? currency;

  Mint({
    this.model,
    this.address,
    this.mintAuthorityAddress,
    this.freezeAuthorityAddress,
    this.decimals,
    this.supply,
    this.isWrappedSol,
    this.currency,
  });

  factory Mint.fromJson(Map<String, dynamic> json) => _$MintFromJson(json);

  Map<String, dynamic> toJson() => _$MintToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Supply {
  String? basisPoints;
  Currency? currency;

  Supply({
    this.basisPoints,
    this.currency,
  });

  factory Supply.fromJson(Map<String, dynamic> json) => _$SupplyFromJson(json);

  Map<String, dynamic> toJson() => _$SupplyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Currency {
  String? symbol;
  int? decimals;
  String? namespace;

  Currency({this.symbol, this.decimals, this.namespace});

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Edition {
  String? model;
  bool? isOriginal;
  String? address;
  String? supply;
  String? maxSupply;

  Edition({this.model, this.isOriginal, this.address, this.supply, this.maxSupply});

  factory Edition.fromJson(Map<String, dynamic> json) => _$EditionFromJson(json);

  Map<String, dynamic> toJson() => _$EditionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Collection {
  bool? verified;
  String? key;
  String? address;

  Collection({this.verified, this.key, this.address});

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CollectionDetails {
  String? version;
  String? size;

  CollectionDetails({this.version, this.size});

  factory CollectionDetails.fromJson(Map<String, dynamic> json) => _$CollectionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionDetailsToJson(this);
}
