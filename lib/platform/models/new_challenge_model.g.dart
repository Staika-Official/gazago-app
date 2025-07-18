// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewChallengeModel _$NewChallengeModelFromJson(Map<String, dynamic> json) =>
    NewChallengeModel(
      id: (json['id'] as num).toInt(),
      challengeType: json['challengeType'] as String,
      challengeState: json['challengeState'] as String?,
      challengeUserState: json['challengeUserState'] as String?,
      challengeActivationType: json['challengeActivationType'] as String,
      exerciseTypes: (json['exerciseTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      subTitle: json['subTitle'] as String?,
      minDistance: (json['minDistance'] as num?)?.toInt(),
      quantity: (json['quantity'] as num).toInt(),
      soldQuantity: (json['soldQuantity'] as num?)?.toInt(),
      publishedDate: json['publishedDate'] as String?,
      reservedDate: json['reservedDate'] as String?,
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      imageUrl: json['imageUrl'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      infinityDisplayed: json['infinityDisplayed'] as bool?,
      previewDisplayed: json['previewDisplayed'] as bool?,
      challengeRewardRuleType: json['challengeRewardRuleType'] as String?,
      rewardAmount: (json['rewardAmount'] as num).toInt(),
      introduce: json['introduce'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$NewChallengeModelToJson(NewChallengeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeState': instance.challengeState,
      'challengeUserState': instance.challengeUserState,
      'challengeType': instance.challengeType,
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
      'introduce': instance.introduce,
      'description': instance.description,
    };
