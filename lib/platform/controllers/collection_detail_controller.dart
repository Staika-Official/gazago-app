import 'dart:async';

import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/services/collection_service.dart';
import 'package:get/get.dart';

class CollectionDetailController extends GetxController {
  CollectionModel detailCollection = CollectionModel(
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
    detailCollection = Get.arguments['item'];
    print(detailCollection);
  }





}
