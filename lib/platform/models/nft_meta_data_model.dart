import 'package:gaza_go/platform/models/nft_properties_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_meta_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NftMetaData {
  String? name;
  String? image;
  Properties? properties;
  Collection? collection;
  List<Attribute>? attributes;

  NftMetaData({
    this.name,
    this.image,
    this.properties,
    this.collection,
    this.attributes,
  });

  factory NftMetaData.fromJson(Map<String, dynamic> json) => _$NftMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$NftMetaDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Attribute {
  @JsonKey(name: 'trait_type')
  String traitType;
  dynamic value;

  Attribute({required this.traitType, this.value});

  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Collection {
  String? family;
  String? name;

  Collection({this.family, this.name});

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}
