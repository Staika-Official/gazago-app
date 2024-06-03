import 'dart:async';

import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/services/collection_service.dart';
import 'package:get/get.dart';

class CollectionController extends SuperController {
  RxList<CollectionModel> collectionList = RxList.empty();
  CollectionModel fixedCollection = CollectionModel(
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
  );
  RxList<UserItemsSummariesModel> myAllItems = RxList.empty();
  RxList<UserBadgesSummariesModel> myAllBadges = RxList.empty();

  @override
  void onInit() async {
    initController();
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

  Future<void> getAllCollectionList() async {
    await CollectionService.getCollectionsList(
        successCallback:(List<CollectionModel> data){
          // 100대 명산 컬렉션 정보
          fixedCollection = data.firstWhere((item) => item.type == 'FIXED');
          collectionList.value = data.where((item) => item.type != 'FIXED').toList();

          checkPercentage(fixedCollection.gatheringConditions);
          print('fixedCollection : ${fixedCollection.toJson()}');
        } ,
        errorCallback:(ErrorResponseDataModel? error){
        }
    );
  }

  Future<void> getUserAllItemList() async {
    await CollectionService.getUserAllItems(
        successCallback:(List<UserItemsSummariesModel> data){
          myAllItems.value = data;
          print('myAllItems : $myAllItems');
        } ,
        errorCallback:(ErrorResponseDataModel? error){
        }
    );
  }

  Future<void> getUserAllBadgeList() async {
    await CollectionService.getUserAllBadges(
        successCallback:(List<UserBadgesSummariesModel> data){
          myAllBadges.value = data;
          print('myAllBadges : $myAllBadges');
        } ,
        errorCallback:(ErrorResponseDataModel? error){
        }
    );
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
