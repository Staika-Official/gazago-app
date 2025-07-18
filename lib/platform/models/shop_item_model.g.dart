// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemModel _$ShopItemModelFromJson(Map<String, dynamic> json) =>
    ShopItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      challengeId: (json['challengeId'] as num?)?.toInt(),
      challengeBannerImageUrl: json['challengeBannerImageUrl'] as String?,
      itemImageUrl: json['itemImageUrl'] as String?,
      itemCategory: json['itemCategory'] as String?,
      itemGrade: json['itemGrade'] as String,
      minGoProfit: (json['minGoProfit'] as num?)?.toDouble() ?? 0,
      maxGoProfit: (json['maxGoProfit'] as num?)?.toDouble() ?? 0,
      minDurability: (json['minDurability'] as num?)?.toDouble() ?? 0,
      maxDurability: (json['maxDurability'] as num?)?.toDouble() ?? 0,
      minStamina: (json['minStamina'] as num?)?.toDouble() ?? 0,
      maxStamina: (json['maxStamina'] as num?)?.toDouble() ?? 0,
      minLuck: (json['minLuck'] as num?)?.toDouble() ?? 0,
      maxLuck: (json['maxLuck'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num).toDouble(),
      itemLabel: json['itemLabel'] as String?,
      description: json['description'] as String?,
      publishType: json['publishType'] as String?,
      tradeSymbol: json['tradeSymbol'] as String?,
      recoveryStamina: (json['recoveryStamina'] as num?)?.toDouble(),
      repairDurability: (json['repairDurability'] as num?)?.toDouble(),
      challenge: json['challenge'] == null
          ? null
          : ShopItemChallengeModel.fromJson(
              json['challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopItemModelToJson(ShopItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeId': instance.challengeId,
      'name': instance.name,
      'itemImageUrl': instance.itemImageUrl,
      'challengeBannerImageUrl': instance.challengeBannerImageUrl,
      'itemCategory': instance.itemCategory,
      'itemGrade': instance.itemGrade,
      'minGoProfit': instance.minGoProfit,
      'maxGoProfit': instance.maxGoProfit,
      'minDurability': instance.minDurability,
      'maxDurability': instance.maxDurability,
      'minStamina': instance.minStamina,
      'maxStamina': instance.maxStamina,
      'minLuck': instance.minLuck,
      'maxLuck': instance.maxLuck,
      'price': instance.price,
      'itemLabel': instance.itemLabel,
      'description': instance.description,
      'publishType': instance.publishType,
      'tradeSymbol': instance.tradeSymbol,
      'recoveryStamina': instance.recoveryStamina,
      'repairDurability': instance.repairDurability,
      'challenge': instance.challenge?.toJson(),
    };
