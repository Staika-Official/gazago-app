// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemChallengeModel _$ShopItemChallengeModelFromJson(
        Map<String, dynamic> json) =>
    ShopItemChallengeModel(
      challengeId: (json['challengeId'] as num?)?.toInt(),
      bannerImageUrl: json['bannerImageUrl'] as String?,
      extBtnLabel: json['extBtnLabel'] as String?,
      extTxt: json['extTxt'] as String?,
      extTxtDetail: json['extTxtDetail'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );

Map<String, dynamic> _$ShopItemChallengeModelToJson(
        ShopItemChallengeModel instance) =>
    <String, dynamic>{
      'challengeId': instance.challengeId,
      'bannerImageUrl': instance.bannerImageUrl,
      'extBtnLabel': instance.extBtnLabel,
      'extTxt': instance.extTxt,
      'extTxtDetail': instance.extTxtDetail,
      'linkUrl': instance.linkUrl,
    };
