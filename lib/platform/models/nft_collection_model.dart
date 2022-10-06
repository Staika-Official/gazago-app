import 'package:json_annotation/json_annotation.dart';

part 'nft_collection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NftCollectionModel {
  String? dummy;

  NftCollectionModel({
    this.dummy,
  });

  factory NftCollectionModel.fromJson(Map<String, dynamic> json) => _$NftCollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftCollectionModelToJson(this);
}
