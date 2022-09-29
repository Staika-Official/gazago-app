import 'package:gaza_go/platform/models/nft_collection_model.dart';
import 'package:gaza_go/platform/models/nft_properties_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_meta_model.g.dart';

@JsonSerializable()
class NftMetaModel {
  String name;
  String symbol;
  String description;
  int seller_fee_basis_points;
  String image;
  List<NftMetaModel> attributes;
  NftCollectionModel collection;
  NftPropertiesModel properties;

  NftMetaModel({
    required this.name,
    required this.symbol,
    required this.description,
    required this.seller_fee_basis_points,
    required this.image,
    required this.attributes,
    required this.collection,
    required this.properties,
  });

  factory NftMetaModel.fromJson(Map<String, dynamic> json) => _$NftMetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftMetaModelToJson(this);
}
