import 'dart:async';

import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/collection_reward_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/services/collection_service.dart';
import 'package:get/get.dart';

class CollectionRewardDetailController extends GetxController {
  GatheringConditionModel gatheringRewardData = GatheringConditionModel(
    id: 0,
    type: '',
    quantity: 0,
  );
  CollectionRewardModel rewardItem = CollectionRewardModel(
    id: 0,
    name: "Fixed Collection",
    description: "Fixed Collection",
    type: '',
    imageUrl: '',
  );



  @override
  void onInit() async {
    gatheringRewardData = Get.arguments['item'];
    await initController();
    super.onInit();
  }

  @override
  void onReady() async {

    super.onReady();
  }

  @override
  void onClose() {
    rewardItem = CollectionRewardModel(
      id: 0,
      name: "",
      description: "",
      type: '',
      imageUrl: '',
    );
    super.onClose();
  }

  Future<void> initController() async {

    if(gatheringRewardData.type == 'ITEM' && gatheringRewardData.item != null){
      rewardItem.type = 'ITEM';
      rewardItem.id = gatheringRewardData.item!.id;
      rewardItem.name = gatheringRewardData.item!.name;
      rewardItem.imageUrl = gatheringRewardData.item!.imageUrl;
      rewardItem.description = gatheringRewardData.item!.description!;
      rewardItem.itemGrade = gatheringRewardData.item!.itemGrade;
      rewardItem.minGoProfit = gatheringRewardData.item!.minGoProfit;
      rewardItem.maxGoProfit = gatheringRewardData.item!.maxGoProfit;
      rewardItem.minDurability = gatheringRewardData.item!.minDurability;
      rewardItem.maxDurability = gatheringRewardData.item!.maxDurability;
      rewardItem.publishType = gatheringRewardData.item!.publishType;
      // rewardItem.minLuck = gatheringRewardData.item!.minLuck;
      // rewardItem.maxLuck = gatheringRewardData.item!.maxLuck;
      // rewardItem.minStamina = gatheringRewardData.item!.minStamina;
      // rewardItem.maxStamina = gatheringRewardData.item!.maxStamina;
      rewardItem.minLuck = 50;
      rewardItem.maxLuck = 100;
      rewardItem.minStamina = 50;
      rewardItem.maxStamina = 100;

    } else {
      rewardItem.type = 'BADGE';
      rewardItem.id = gatheringRewardData.badgeComposeConfig!.id;
      rewardItem.name = gatheringRewardData.badgeComposeConfig!.name;
      rewardItem.imageUrl = gatheringRewardData.badgeComposeConfig!.imageUrl;
      rewardItem.description = gatheringRewardData.badgeComposeConfig!.description != null ? gatheringRewardData.badgeComposeConfig!.description! : '';
      rewardItem.luckRateFrom = gatheringRewardData.badgeComposeConfig!.luckRateFrom;
      rewardItem.luckRateTo = gatheringRewardData.badgeComposeConfig!.luckRateTo;
      rewardItem.rewardRateFrom = gatheringRewardData.badgeComposeConfig!.rewardRateFrom;
      rewardItem.rewardRateTo = gatheringRewardData.badgeComposeConfig!.rewardRateTo;

    }

  }



}
