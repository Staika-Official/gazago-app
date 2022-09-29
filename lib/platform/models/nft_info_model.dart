import 'package:gaza_go/platform/models/nft_meta_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_info_model.g.dart';

@JsonSerializable()
class NftInfoModel {
  String mint;
  String updateAuthority;
  NftMetaModel meta;

  NftInfoModel({
    required this.mint,
    required this.updateAuthority,
    required this.meta,
  });

  factory NftInfoModel.fromJson(Map<String, dynamic> json) => _$NftInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NftInfoModelToJson(this);
}
