// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemModel _$InventoryItemModelFromJson(Map<String, dynamic> json) =>
    InventoryItemModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      nftId: (json['nftId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      serialNumber: json['serialNumber'] as String?,
      itemGrade: json['itemGrade'] as String,
      itemName: json['itemName'] as String,
      itemType: json['itemType'] as String?,
      expiredDate: json['expiredDate'] as String?,
      publishType: json['publishType'] as String?,
      itemCategory: json['itemCategory'] as String,
      durability: (json['durability'] as num?)?.toDouble(),
      abrasionRate: (json['abrasionRate'] as num?)?.toDouble(),
      rewardRate: (json['rewardRate'] as num?)?.toDouble(),
      staminaReduceRate: (json['staminaReduceRate'] as num?)?.toDouble(),
      itemImageUrl: json['itemImageUrl'] as String,
      itemStat: json['itemStat'] == null
          ? null
          : InventoryItemStatModel.fromJson(
              json['itemStat'] as Map<String, dynamic>),
      description: json['description'] as String?,
      tokenAddress: json['tokenAddress'] as String?,
      nftTokenAddress: json['nftTokenAddress'] as String?,
      equipped: json['equipped'] as bool?,
      listOrder: (json['listOrder'] as num?)?.toInt(),
      equippedChallengeItem: json['equippedChallengeItem'] as bool?,
      challengeItem: json['challengeItem'] as bool?,
      amount: (json['amount'] as num?)?.toInt(),
      tik: (json['tik'] as num?)?.toInt() ?? 0,
      isShoe: json['isShoe'] as bool? ?? false,
      challenge: json['challenge'] == null
          ? null
          : ShopItemChallengeModel.fromJson(
              json['challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InventoryItemModelToJson(InventoryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemId': instance.itemId,
      'nftId': instance.nftId,
      'serialNumber': instance.serialNumber,
      'itemName': instance.itemName,
      'publishType': instance.publishType,
      'itemCategory': instance.itemCategory,
      'itemGrade': instance.itemGrade,
      'itemType': instance.itemType,
      'expiredDate': instance.expiredDate,
      'durability': instance.durability,
      'abrasionRate': instance.abrasionRate,
      'rewardRate': instance.rewardRate,
      'staminaReduceRate': instance.staminaReduceRate,
      'itemImageUrl': instance.itemImageUrl,
      'description': instance.description,
      'tokenAddress': instance.tokenAddress,
      'nftTokenAddress': instance.nftTokenAddress,
      'equipped': instance.equipped,
      'challengeItem': instance.challengeItem,
      'equippedChallengeItem': instance.equippedChallengeItem,
      'listOrder': instance.listOrder,
      'tik': instance.tik,
      'isShoe': instance.isShoe,
      'amount': instance.amount,
      'itemStat': instance.itemStat?.toJson(),
      'challenge': instance.challenge?.toJson(),
    };
