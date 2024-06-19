import 'package:gaza_go/platform/models/creators_model.dart';
import 'package:gaza_go/platform/models/nft_meta_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NftModel {
  String? model;
  String? address;
  String? mintAddress;
  String? updateAuthorityAddress;
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
  NftMetaData? metadata;

  NftModel({
    this.model,
    this.address,
    this.mintAddress,
    this.updateAuthorityAddress,
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
    this.metadata,
  });

  factory NftModel.fromJson(Map<String, dynamic> json) => _$NftModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftModelToJson(this);
}
