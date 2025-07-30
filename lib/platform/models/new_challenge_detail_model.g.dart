// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_challenge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewChallengeDetailModel _$NewChallengeDetailModelFromJson(
        Map<String, dynamic> json) =>
    NewChallengeDetailModel(
      id: (json['id'] as num?)?.toInt(),
      itemTradeStoreId: (json['itemTradeStoreId'] as num?)?.toInt(),
      challengeType: json['challengeType'] as String?,
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
      entryFee: (json['entryFee'] as num?)?.toInt(),
      publishedDate: json['publishedDate'] as String?,
      reservedDate: json['reservedDate'] as String?,
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
      imageUrl: json['imageUrl'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      infinityDisplayed: json['infinityDisplayed'] as bool?,
      previewDisplayed: json['previewDisplayed'] as bool?,
      challengeRewardRuleType: json['challengeRewardRuleType'] as String?,
      rewardAmount: (json['rewardAmount'] as num?)?.toInt(),
      rewardQuantity: (json['rewardQuantity'] as num?)?.toInt(),
      introduce: json['introduce'] as String?,
      description: json['description'] as String?,
      item: json['item'] == null
          ? null
          : NewChallengeItemModel.fromJson(
              json['item'] as Map<String, dynamic>),
      userItem: json['userItem'] == null
          ? null
          : NewChallengeUserItemModel.fromJson(
              json['userItem'] as Map<String, dynamic>),
      badge: json['badge'] == null
          ? null
          : NewChallengeBadgeModel.fromJson(
              json['badge'] as Map<String, dynamic>),
      badges: (json['badges'] as List<dynamic>?)
          ?.map(
              (e) => NewChallengeBadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      extBtnLabel: json['extBtnLabel'] as String?,
      extTxt: json['extTxt'] as String?,
      extTxtDetail: json['extTxtDetail'] as String?,
      limitedPeriod: json['limitedPeriod'] as bool?,
      challengeLanding: json['challengeLanding'] == null
          ? null
          : ChallengeLandingModel.fromJson(
              json['challengeLanding'] as Map<String, dynamic>),
      usedImageContent: json['usedImageContent'] as bool?,
    );

Map<String, dynamic> _$NewChallengeDetailModelToJson(
        NewChallengeDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemTradeStoreId': instance.itemTradeStoreId,
      'challengeType': instance.challengeType,
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
      'linkUrl': instance.linkUrl,
      'infinityDisplayed': instance.infinityDisplayed,
      'previewDisplayed': instance.previewDisplayed,
      'challengeRewardRuleType': instance.challengeRewardRuleType,
      'rewardAmount': instance.rewardAmount,
      'rewardQuantity': instance.rewardQuantity,
      'entryFee': instance.entryFee,
      'introduce': instance.introduce,
      'description': instance.description,
      'item': instance.item?.toJson(),
      'userItem': instance.userItem?.toJson(),
      'badge': instance.badge?.toJson(),
      'badges': instance.badges?.map((e) => e.toJson()).toList(),
      'extBtnLabel': instance.extBtnLabel,
      'extTxt': instance.extTxt,
      'extTxtDetail': instance.extTxtDetail,
      'limitedPeriod': instance.limitedPeriod,
      'challengeLanding': instance.challengeLanding?.toJson(),
      'usedImageContent': instance.usedImageContent,
    };
