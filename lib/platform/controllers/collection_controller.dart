import 'dart:async';

import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
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
    await getAllCollectionList();

  }

  Future<void> getAllCollectionList() async {
    await CollectionService.getCollectionsList(
        successCallback:(List<CollectionModel> data){
          collectionList.value = data;
          // 100대 명산 컬렉션 정보
          fixedCollection = data.firstWhere((item) => item.type == 'FIXED');

          print('fixedCollection : $fixedCollection');
        } ,
        errorCallback:(ErrorResponseDataModel? error){
        }
    );
  }

  Future<void> getUserAllItemList() async {

  }

  Future<void> getUserAllBadgeList() async {

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
