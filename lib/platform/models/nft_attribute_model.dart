import 'package:json_annotation/json_annotation.dart';

part 'nft_attribute_model.g.dart';

@JsonSerializable()
class NftAttributeModel {
  String trait_type;
  String value;

  NftAttributeModel({
    required this.trait_type,
    required this.value,
  });

  factory NftAttributeModel.fromJson(Map<String, dynamic> json) => _$NftAttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftAttributeModelToJson(this);
}
