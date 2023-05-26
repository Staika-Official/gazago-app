import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/challenge_ranker_model.dart';
import 'package:gaza_go/platform/models/challenge_reward_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChallengesDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  LoaderController loaderController = Get.put(LoaderController());
  Rx<DateTime?> today = Rx(DateTime.now());
  RxString fromDate = RxString('');
  RxString toDate = RxString('');
  RxInt dDay = RxInt(0);
  RxInt inDays = RxInt(0);

  late TabController tabController;
  final GlobalKey backgroundKey = GlobalKey();
  final RxDouble backgroundBoxSize = RxDouble(0.0);
  ScrollController challengeDetailScrollController = ScrollController();
  RxBool isHeightCalculated = RxBool(false);
  RxInt challengeTabIndex = RxInt(0);
  RxInt challengeId = RxInt(0);
  final Rx<NewChallengeDetailModel> challengeDetails = Rx(NewChallengeDetailModel());
  Rxn<ChallengeRankerModel> myRank = Rxn();
  Rx<ChallengeRewardModel> challengeRewardPool = Rx(ChallengeRewardModel());
  RxList<ChallengeRankerModel> challengeRankingList = RxList.empty();
  final RxBool dataGetLoading = RxBool(false);
  ScrollController leaderboardScrollController = ScrollController();
  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 1) {}
      });
    tabController.addListener(_tabController);
    challengeId.value = await Get.arguments['id'];
    getChallengeDetail();
    getChallengeLeaderboard();
    getChallengeLeaderboardMyRanking();

    super.onInit();
  }

  @override
  void onReady() {
    // getSize();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshController() async {
    getChallengeDetail();
  }

  void _tabController() {
    challengeTabIndex.value = tabController.index;
  }

  void showMoveToShopItem() {
    moveBuyChallengeItemPageAlert(this, challengeDetails.value.itemTradeStoreId!);
  }

  void fetchEquipItem(int itemId) async {
    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) {
        showToastPopup('아이템이 장착되었습니다.');
        getChallengeDetail();
      },
    );
  }

  Future<void> getChallengeDetail() async {
    // loaderController.isLoading.value = true;
    await ActivityService.getChallengeDetails(challengeId.value, successCallback: (NewChallengeDetailModel data) {
      challengeDetails.value = data;
      // loaderController.isLoading.value = false;
      fromDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.fromDate!));
      toDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.toDate!));
      inDays.value = DateTime.parse(data.toDate!).difference(DateTime.parse(data.fromDate!)).inDays;
    });
  }

  Future<void> getChallengeLeaderboard() async {
    await ActivityService.getChallengeLeaderboard(challengeId.value, successCallback: (data) {
      data.asMap().forEach((index, ranker) {
        ranker.rank = (index + 1);
      });
      challengeRankingList.addAll(data);
    });
  }

  Future<void> getChallengeLeaderboardMyRanking() async {
    await ActivityService.getChallengeLeaderboardMyRanking(challengeId.value, successCallback: (ChallengeRankerModel? data) {
      myRank.value = data;
    });
  }

  void getSize() {
    if (backgroundKey.currentContext != null) {
      backgroundBoxSize.value = backgroundKey.currentContext!.size!.height;
    }
  }
}
