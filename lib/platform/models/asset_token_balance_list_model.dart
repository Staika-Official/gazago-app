import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_token_balance_list_model.g.dart';

@JsonSerializable()
class AssetTokenBalanceListModel {
  List<AssetTokenBalanceModel> tokens;

  AssetTokenBalanceListModel({
    required this.tokens,
  });

  factory AssetTokenBalanceListModel.fromJson(Map<String, dynamic> json) => _$AssetTokenBalanceListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTokenBalanceListModelToJson(this);
}
