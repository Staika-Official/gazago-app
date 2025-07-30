// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_purchase_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemPurchaseResponseModel _$ShopItemPurchaseResponseModelFromJson(
        Map<String, dynamic> json) =>
    ShopItemPurchaseResponseModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      nftId: (json['nftId'] as num?)?.toInt(),
      serialNumber: json['serialNumber'] as String?,
      itemName: json['itemName'] as String,
      itemImageUrl: json['itemImageUrl'] as String,
      publishType: json['publishType'] as String?,
      itemCategory: json['itemCategory'] as String,
      itemGrade: json['itemGrade'] as String,
      durability: (json['durability'] as num).toDouble(),
      abrasionRate: (json['abrasionRate'] as num?)?.toDouble(),
      rewardRate: (json['rewardRate'] as num?)?.toDouble(),
      staminaReduceRate: (json['staminaReduceRate'] as num?)?.toDouble(),
      description: json['description'] as String?,
      expiredDate: json['expiredDate'] as String?,
      itemStat: json['itemStat'] == null
          ? null
          : InventoryItemStatModel.fromJson(
              json['itemStat'] as Map<String, dynamic>),
      equippedChallengeItem: json['equippedChallengeItem'] as bool?,
      equipped: json['equipped'] as bool?,
      challenge: json['challenge'] == null
          ? null
          : ShopItemChallengeModel.fromJson(
              json['challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopItemPurchaseResponseModelToJson(
        ShopItemPurchaseResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nftId': instance.nftId,
      'serialNumber': instance.serialNumber,
      'itemName': instance.itemName,
      'itemImageUrl': instance.itemImageUrl,
      'publishType': instance.publishType,
      'itemCategory': instance.itemCategory,
      'itemGrade': instance.itemGrade,
      'durability': instance.durability,
      'abrasionRate': instance.abrasionRate,
      'rewardRate': instance.rewardRate,
      'staminaReduceRate': instance.staminaReduceRate,
      'description': instance.description,
      'expiredDate': instance.expiredDate,
      'itemStat': instance.itemStat?.toJson(),
      'equippedChallengeItem': instance.equippedChallengeItem,
      'equipped': instance.equipped,
      'challenge': instance.challenge?.toJson(),
    };
