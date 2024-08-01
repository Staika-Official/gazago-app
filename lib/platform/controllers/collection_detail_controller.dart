import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/platform/controllers/collection_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/services/collection_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class CollectionDetailController extends GetxController {
  WalletMasterController walletMasterController = Get.find();
  CollectionController collectionController = Get.find();
  Rx<CollectionModel> detailCollection = Rx(CollectionModel(
    id: 0,
    name: "Fixed Collection",
    description: "Fixed Collection",
    type: '',
    gatheringDifficultyType: '',
    imageUrl: '',
    grayscaleImageUrl: '',
    gatheringConditions: [],
    gatheringReward: GatheringConditionModel(id: 0, type: '', quantity: 0),
    alreadyIssued: false,
    completeQuantity: 0,
  ));



  @override
  void onInit() async {
    collectionController.selectedCollection.listen((event) {
      detailCollection.value  = event;
      detailCollection.refresh();

    });

    await initController();


    super.onInit();
  }



  @override
  void onResumed() async {
    print('onResumed collection');

  }

  @override
  void onReady() async {

    super.onReady();
  }

  @override
  void onClose() {

    super.onClose();
  }


  Future<void> refreshController() async {
    await initController();
  }

  Future<void> initController() async {
    detailCollection.value = collectionController.selectedCollection.value;

    // 삭제 요망

    if(detailCollection.value.completeQuantity == detailCollection.value.gatheringConditions.length){
      detailCollection.value.getAble = true;
      detailCollection.refresh();

    }
    print(detailCollection.toJson());
  }


  double currentMyTokenCondition(itemType, requireQuantity) {
    double parseAmount(AssetTokenBalanceModel token) {
      return double.parse(token.uiAmountString.toString()) >= requireQuantity
          ? requireQuantity
          : double.parse(token.uiAmountString.toString());
    }
    switch (itemType) {
      case 'TIK':
        return parseAmount(walletMasterController.originTik.value);
      case 'PTIK':
        return parseAmount(walletMasterController.ptik.value);
      case 'STIK':
        return parseAmount(walletMasterController.stik.value);
      default:
        return 0.0;
    }
  }

  double currentMyTokenConditionPercentage(itemType, quantity) {
    double parseAndCalculatePercentage(String uiAmountString, double quantity) {
      double amount = double.parse(uiAmountString).floorToDouble();

      return (amount / quantity) >= 1 ? 100 : (amount / quantity) * 100;
    }

    switch (itemType) {
      case 'TIK':
        return parseAndCalculatePercentage(walletMasterController.originTik.value.uiAmountString!, quantity);
      case 'PTIK':
        return parseAndCalculatePercentage(walletMasterController.ptik.value.uiAmountString!, quantity);
      case 'STIK':
        return parseAndCalculatePercentage(walletMasterController.stik.value.uiAmountString!, quantity);
      default:
        return 0.0;
    }
  }

  bool imageConditions(itemType, quantity) {
    bool parseAndCheckCondition(String uiAmountString, double quantity) {
      return (double.parse(uiAmountString) / quantity) >= 1;
    }

    switch (itemType) {
      case 'TIK':
        return parseAndCheckCondition(walletMasterController.originTik.value.uiAmountString!, quantity);
      case 'PTIK':
        return parseAndCheckCondition(walletMasterController.ptik.value.uiAmountString!, quantity);
      case 'STIK':
        return parseAndCheckCondition(walletMasterController.stik.value.uiAmountString!, quantity);
      default:
        return false;
    }
  }

  Widget renderCollectionImage(gatheringReward){
    String imageUrl = '';
    if(gatheringReward.type == 'BADGE' || gatheringReward.type == 'ITEM'){
      if (gatheringReward.badgeComposeConfig != null) {
        imageUrl = gatheringReward.badgeComposeConfig.imageUrl;
      } else if (gatheringReward.item != null) {
        imageUrl = gatheringReward.item.imageUrl;
      }

      if(imageUrl.contains('.svg')){
        return SvgPicture.network(
          imageUrl,
          width: 148.sp,
          height: 148.sp,
          placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(color:skyBlueColor),
        );
      } else {
        return Image.network(
          imageUrl,
          width: 148.sp,
          height: 148.sp,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        );
      }
    } else {
      if(gatheringReward.type == 'TIK' || gatheringReward.type == 'PTIK'){
        return SvgPicture.asset('assets/images/collection/ico_collection_token_tik.svg', width: 148.sp, height: 148.sp);
      } else {
        return SvgPicture.asset('assets/images/collection/ico_collection_token_stik.svg', width: 148.sp, height: 148.sp);
      }
    }
  }

  String gatheringRewardName(gatheringRewardData){
    String rewardString = '';
    String type = gatheringRewardData.type;
    switch(type){
      case 'BADGE':
        rewardString = gatheringRewardData.badgeComposeConfig.name;
        break;
      case 'ITEM':
        rewardString = gatheringRewardData.item.name;
        break;
      case 'TIK':
        rewardString = '${formatDecimalPlaces(gatheringRewardData.quantity, 0)} TIK';
        break;
      case 'PTIK':
        rewardString = '${formatDecimalPlaces(gatheringRewardData.quantity, 0)} TIK';
        break;
      case 'STIK':
        rewardString = '${formatDecimalPlaces(gatheringRewardData.quantity, 0)} STIK';
        break;
      default:
        rewardString = '';
        break;
    }
    return rewardString;
  }


  bool checkCollectionExpired(date){
    DateTime targetTime = DateTime.parse(date);
    DateTime currentTime = DateTime.now();
    bool isExpired = currentTime.isAfter(targetTime);
    return isExpired;
  }

  Future<void> getCollectionReward(int gatheringId) async {
    await CollectionService.getCollectionReward(gatheringId,
        successCallback: (data){
          showGetCollectionRewardAlert(data);
          // detailCollection.value.gatheringReward = data;
        },
        errorCallback: (ErrorResponseDataModel error){
          if (error.errorCode == 'NOT_ENOUGH_GATHERING_CONDITION') {
            // 요구 품목이 부족할 경우
            showNotEnoughGatheringConditionErrorAlert();
          } else {
            // 그 외 에러
            showGetCollectionRewardErrorAlert();
          }
        }
    );
  }


  void confirmGetReward(){
    Get.back();

    collectionController.initController();
    walletMasterController.initializeController();

  }



}
