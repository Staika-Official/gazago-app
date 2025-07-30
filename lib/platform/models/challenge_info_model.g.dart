// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeInfoModel _$ChallengeInfoModelFromJson(Map<String, dynamic> json) =>
    ChallengeInfoModel(
      id: (json['id'] as num?)?.toInt(),
      item: json['item'] == null
          ? null
          : ChallengeItemModel.fromJson(json['item'] as Map<String, dynamic>),
      userItem: json['userItem'] as String?,
      badge: json['badge'] == null
          ? null
          : ChallengeBadgeModel.fromJson(json['badge'] as Map<String, dynamic>),
      badges: (json['badges'] as List<dynamic>?)
          ?.map((e) => ChallengeBadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemTradeStoreId: (json['itemTradeStoreId'] as num?)?.toInt(),
      challengeState: json['challengeState'] as String?,
      challengeUserState: json['challengeUserState'] as String?,
      challengeActivationType: json['challengeActivationType'] as String?,
      exerciseTypes: (json['exerciseTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      minDistance: (json['minDistance'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      soldQuantity: (json['soldQuantity'] as num?)?.toInt(),
      publishedDate: json['publishedDate'] as String?,
      reservedDate: json['reservedDate'] as String?,
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
      imageUrl: json['imageUrl'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      allianceType: json['allianceType'] as String?,
      linkUrl: json['linkUrl'] as String?,
      extBtnLabel: json['extBtnLabel'] as String?,
      extTxt: json['extTxt'] as String?,
      extTxtDetail: json['extTxtDetail'] as String?,
      previewDisplayed: json['previewDisplayed'] as bool?,
      challengeRewardRuleType: json['challengeRewardRuleType'] as String?,
      rewardAmount: (json['rewardAmount'] as num?)?.toInt(),
      rewardQuantity: (json['rewardQuantity'] as num?)?.toInt(),
      introduce: json['introduce'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ChallengeInfoModelToJson(ChallengeInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item?.toJson(),
      'userItem': instance.userItem,
      'badge': instance.badge?.toJson(),
      'badges': instance.badges?.map((e) => e.toJson()).toList(),
      'itemTradeStoreId': instance.itemTradeStoreId,
      'challengeState': instance.challengeState,
      'challengeUserState': instance.challengeUserState,
      'challengeActivationType': instance.challengeActivationType,
      'exerciseTypes': instance.exerciseTypes,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'minDistance': instance.minDistance,
      'quantity': instance.quantity,
      'soldQuantity': instance.soldQuantity,
      'publishedDate': instance.publishedDate,
      'reservedDate': instance.reservedDate,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'imageUrl': instance.imageUrl,
      'bannerImageUrl': instance.bannerImageUrl,
      'thumbnailImageUrl': instance.thumbnailImageUrl,
      'allianceType': instance.allianceType,
      'linkUrl': instance.linkUrl,
      'extBtnLabel': instance.extBtnLabel,
      'extTxt': instance.extTxt,
      'extTxtDetail': instance.extTxtDetail,
      'previewDisplayed': instance.previewDisplayed,
      'challengeRewardRuleType': instance.challengeRewardRuleType,
      'rewardAmount': instance.rewardAmount,
      'rewardQuantity': instance.rewardQuantity,
      'introduce': instance.introduce,
      'description': instance.description,
    };
