import 'package:json_annotation/json_annotation.dart';

part 'nft_properties_model.g.dart';

@JsonSerializable()
class NftPropertiesModel {
  String? dummy;

  NftPropertiesModel({
    this.dummy,
  });

  factory NftPropertiesModel.fromJson(Map<String, dynamic> json) => _$NftPropertiesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftPropertiesModelToJson(this);
}
