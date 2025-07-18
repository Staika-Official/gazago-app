import 'package:json_annotation/json_annotation.dart';

part 'shop_item_challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItemChallengeModel {
  int? challengeId;
  String? bannerImageUrl;
  String? extBtnLabel;
  String? extTxt;
  String? extTxtDetail;
  String? linkUrl;

  ShopItemChallengeModel({
    this.challengeId,
    this.bannerImageUrl,
    this.extBtnLabel,
    this.extTxt,
    this.extTxtDetail,
    this.linkUrl,
  });

  factory ShopItemChallengeModel.fromJson(Map<String, dynamic> json) => _$ShopItemChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemChallengeModelToJson(this);
}
