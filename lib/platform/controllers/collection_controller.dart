import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/services/collection_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class CollectionController extends SuperController with GetTickerProviderStateMixin  {
  ActivityController activityController = Get.find();
  WalletMasterController walletMasterController = Get.find();
  RxList<CollectionModel> collectionList = RxList.empty();
  late AnimationController animationController;
  Rx<CollectionModel> fixedCollection = Rx(CollectionModel(
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
  RxList<UserItemsSummariesModel> myAllItems = RxList.empty();
  RxList<UserBadgesSummariesModel> myAllBadges = RxList.empty();
  final Rx<CollectionModel> selectedCollection = Rx(CollectionModel(
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
  Stream<CollectionModel> get selectedDetailStream => selectedCollection.stream;
  @override
  void onInit() async {
    await initController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    super.onInit();
  }

  @override
  void onReady() async {

    super.onReady();
  }

  @override
  void onClose() {

    super.onClose();
  }

  Future<void> initController() async {
    await getUserAllItemList();
    await getUserAllBadgeList();
    await getAllCollectionList();
  }

  void checkPercentage(data){

    for (var condition in data) {
      if (condition.type == 'ITEM') {
        int itemId = condition.item.id;
        var myItem = myAllItems.firstWhere((item) => item.itemId == itemId && !item.equipped);
        if (myItem != null) {
          double percentage = (myItem.amount / condition.quantity) * 100;
          condition.percentage = percentage;
        }
      } else if(condition.type == 'BADGE'){


      }
    }

  }

  void initData(){
    fixedCollection.value = CollectionModel(
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
    );
    collectionList.value = RxList(List.empty());
  }

  Future<void> getAllCollectionList() async {
    String? loadedString = HiveStore.loadString(key: HiveKey.collectionIdList.name);


    await CollectionService.getCollectionsList(
        successCallback:(List<CollectionModel> data) async {
          List<int> collectionIdList = [];
          collectionIdList = extractIds(data);

          if(selectedCollection.value.id != 0){
            selectedCollection.value = data.firstWhere((item) => item.id == selectedCollection.value.id);
            calculatePercentage(selectedCollection.value);
          }

          print('coleectionID : $collectionIdList');

          // 100대 명산 컬렉션 정보
          if(loadedString == null){
            print(extractIds(data));
            HiveStore.save(key: HiveKey.isNewCollection.name, value: true);
            HiveStore.save(key: HiveKey.collectionIdList.name, value: collectionIdList.toString());
          } else {
            List<dynamic> transformList = jsonDecode(loadedString);
            print('loadedString : $transformList');

            if(transformList.length != collectionIdList.length){
              HiveStore.save(key: HiveKey.isNewCollection.name, value: true);
              HiveStore.save(key: HiveKey.collectionIdList.name, value: collectionIdList.toString());
            }
          }
          fixedCollection.value = data.firstWhere((item) => item.type == 'FIXED');
          collectionList.value = data.where((item) => item.type != 'FIXED').toList();
          sortObjectsByGatheringDifficulty(collectionList);
          await Future.delayed(const Duration(milliseconds: 200));
          calculatePercentage(fixedCollection.value);
          for(var collection in collectionList){
           calculatePercentage(collection);
          }
          activityController.checkNewCollectionStatus();
          fixedCollection.refresh();
          collectionList.refresh();
          selectedCollection.refresh();
        } ,
        errorCallback:(ErrorResponseDataModel? error){
        }
    );
  }

  void sortObjectsByGatheringDifficulty(data) async {
    const difficultyOrder = {
      'LEVEL_1': 1,
      'LEVEL_2': 2,
      'LEVEL_3': 3
    };

     data.sort((a, b) => difficultyOrder[a.gatheringDifficultyType]! - difficultyOrder[b.gatheringDifficultyType]!);
  }

  List<int> extractIds(List<CollectionModel> collectionList) {
    return collectionList.map((collection) => collection.id).toList();
  }

  Future<void> getUserAllItemList() async {
    await CollectionService.getUserAllItems(
        successCallback:(List<UserItemsSummariesModel> data){
          myAllItems.value = data;
        } ,
        errorCallback:(ErrorResponseDataModel? error){
          showToastPopup(error!.errorMessage!);
        }
    );
  }

  Future<void> getUserAllBadgeList() async {
    await CollectionService.getUserAllBadges(
        successCallback:(List<UserBadgesSummariesModel> data){
          myAllBadges.value = data;
        } ,
        errorCallback:(ErrorResponseDataModel? error){
          showToastPopup(error!.errorMessage!);
        }
    );
  }

  void calculatePercentage(CollectionModel data) async {
    for (var condition in data.gatheringConditions) {
      // 내가 가진 뱃지와 조건이 일치하는 뱃지를 찾아서 개수를 세어준다.
      if(condition.type == 'BADGE'){
        if ( condition.badgeComposeConfig != null) {
          int badgeComposeConfigId = condition.badgeComposeConfig!.id;
          int ownedBadgesCount = myAllBadges.where((badge) => (badge.badgeComposeConfigId == badgeComposeConfigId) && badge.state == 'INVENTORY').length;
          condition.completeAmount = ownedBadgesCount;
        } else {
          condition.completeAmount = 0;
        }
      } else if(condition.type == 'ITEM'){
        // 내가 가진 아이템과 조건이 일치하는 아이템을 찾아서 개수를 세어준다.
        if (condition.item != null) {
          int itemId = condition.item!.id;
          int ownedBadgesCount = myAllItems.where((item) => (item.itemId == itemId) && item.equipped == false).length;
          condition.completeAmount = ownedBadgesCount;
        } else {
          condition.completeAmount = 0;
        }
      }else if(condition.type == 'PTIK'){
        if (condition.quantity <= double.parse(walletMasterController.ptik.value.amount.toString())) {
          condition.completeAmount = 1;
        } else {
          condition.completeAmount = 0;
        }
      }else if(condition.type == 'TIK'){

        if (condition.quantity <= double.parse(walletMasterController.originTik.value.amount.toString())) {
          condition.completeAmount = 1;
        } else {
          condition.completeAmount = 0;
        }
      }else if(condition.type == 'STIK'){

        if (condition.quantity <= double.parse(walletMasterController.stik.value.uiAmountString.toString()).floorToDouble()) {
          condition.completeAmount = 1;
        } else {
          condition.completeAmount = 0;
        }
      }

    }

    checkComepleteQuantity(data);

  }

  void checkComepleteQuantity(data){
    int count = 0;
    for (var condition in data.gatheringConditions) {
      double quantity = condition.quantity;
      int? completeAmount = condition.completeAmount != null ? condition.completeAmount : 0;
      if(condition.type == 'ITEM' || condition.type == 'BADGE'){
        if (double.parse(completeAmount.toString()) >= quantity) {
          count++;
        }
      } else {
        if (condition.type == 'PTIK' && condition.quantity <= walletMasterController.ptik.value.amount) {
          count++;
        }

        if (condition.type == 'TIK' && condition.quantity <= walletMasterController.originTik.value.amount) {
          count++;
        }

        if (condition.type == 'STIK' && condition.quantity <= double.parse(walletMasterController.stik.value.uiAmountString.toString())) {
          count++;
        }
      }

    }

    data.completeQuantity = count;
  }

  double currentMyTokenConditionPercentage(itemType , quantity){
    switch(itemType){
      case 'TIK':
        return (double.parse(walletMasterController.originTik.value.uiAmountString!) / quantity) >= 1 ? 100 : double.parse(walletMasterController.originTik.value.uiAmountString!);
      case 'PTIK':
        return (double.parse(walletMasterController.ptik.value.uiAmountString!) / quantity) >= 1 ? 100 : double.parse(walletMasterController.ptik.value.uiAmountString!);
      case 'STIK':
        return (double.parse(walletMasterController.stik.value.uiAmountString!) / quantity) >= 1 ? 100 : double.parse(walletMasterController.stik.value.uiAmountString!);
      default:
        return 0.0;
    }
  }

  void moveToDetailCollection ( item) {
    selectedCollection.value = item;
    selectedCollection.refresh();
    Get.toNamed(Routes.collectionDetail);

  }


  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }



}
