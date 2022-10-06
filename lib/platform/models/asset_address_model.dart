import 'package:json_annotation/json_annotation.dart';

part 'asset_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetAddressModel {
  String publicKey;
  String owner;

  AssetAddressModel({
    required this.publicKey,
    required this.owner,
  });

  factory AssetAddressModel.fromJson(Map<String, dynamic> json) => _$AssetAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetAddressModelToJson(this);
}
