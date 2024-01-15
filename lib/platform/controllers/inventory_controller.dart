import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/consumer_item_mixin.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/helpers/linear_progress_mixin.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InventoryController extends GetxController with LinearProgressMixin, InventoryMixin, ActivityMixin, ConsumerItemMixin, GetTickerProviderStateMixin {
  final WalletMasterController walletMasterController = Get.find();
  ActivityController activityController = Get.isRegistered<ActivityController>() ? Get.find<ActivityController>() : Get.put(ActivityController());
  late AnimationController progressController;
  final RxDouble viewportWidth = RxDouble(0);
  final RxDouble listHeight = RxDouble(0);
  GlobalKey itemDetailViewKey = GlobalKey();
  GlobalKey equippedInfoKey = GlobalKey();
  final RxDouble equippedInfoHeight = RxDouble(0);
  final RxBool isLoaded = RxBool(false);

  RxInt page = RxInt(0);
  RxInt totalItemCount = RxInt(0);
  RxBool stopLoading = RxBool(false);
  RxBool dataGetLoading = RxBool(false);

  final RxList<StatModel> statList = RxList.empty();
  final RxList<InventoryItemModel> myAllItems = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();

  final RxBool isShoe = RxBool(false);
  final RxString getBadgeDate = RxString('');

  final RxBool isDisableButton = RxBool(false);

  final RxBool disableButton = RxBool(false);
  final RxList<InventoryItemModel> equippedItemList = RxList.empty();

  ScrollController singleChildScrollController = ScrollController();
  ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
  ScrollController badgeScrollController = ScrollController(keepScrollOffset: false);

  final Rxn isConsumerItemUsing = Rxn(null);

  Rx<InventoryBadgeModel> equippedBadge = Rx(
    InventoryBadgeModel(
      id: -1,
      userId: -1,
      state: '',
      createdBy: '',
      createdDate: '',
      lastModifiedBy: '',
      lastModifiedDate: '',
      badge: InventoryBadgeItemModel(
        id: -1,
        level: 0,
        rewardRate: 0.0,
        luckRate: 0.0,
        source: '',
        issueType: '',
        issueState: '',
        issueStartedTime: '',
        issueEndedTime: '',
        description: '',
        state: '',
        address: '',
        imageUrl: 'imageUrl',
        createdBy: '',
        createdDate: '',
        lastModifiedBy: '',
        lastModifiedDate: '',
      ),
    ),
  );
  // final Rx<RepairShoesModel> shoesDurability = Rx(RepairShoesModel());
  Rx<InventoryItemModel> selectedItem = Rx(
    InventoryItemModel(
        id: -1,
        serialNumber: '',
        itemGrade: '',
        itemName: '',
        itemCategory: '',
        durability: 0.0,
        itemImageUrl: '',
        itemStat: InventoryItemStatModel(
          goProfit: 0.0,
          durability: 0.0,
          stamina: 0.0,
          luck: 0.0,
          recoveryStamina: 0.0,
          repairDurability: 0.0,
        )),
  );
  Rx<InventoryBadgeListModel> selectedBadge = Rx(
    InventoryBadgeListModel(
      id: -1,
      userId: -1,
      badgeId: -1,
      level: -1,
      state: '',
      imageUrl: '',
      rewardRate: 0.0,
      luckRate: 0.0,
      name: '',
      issueType: '',
      issueEndedTime: '',
    ),
  );

  Rxn get equippedTop {
    return Rxn(equippedItemList.firstWhereOrNull((element) => element.itemCategory == 'TOP'));
  }

  Rxn get equippedShoe {
    return Rxn(equippedItemList.firstWhereOrNull((element) => element.itemCategory == 'SHOES'));
  }

  Rxn get equippedAccessory {
    return Rxn(equippedItemList.firstWhereOrNull((element) => element.itemCategory == 'ACCESSORY'));
  }

  Rxn get equippedBottom {
    return Rxn(equippedItemList.firstWhereOrNull((element) => element.itemCategory == 'BOTTOM'));
  }

  Rxn get equippedHat {
    return Rxn(equippedItemList.firstWhereOrNull((element) => element.itemCategory == 'HAT'));
  }

  RxMap<String, List<InventoryItemModel>> get allItems {
    return RxMap(
      {
        ItemType.all.name: myAllItems,
        ItemType.top.name: myAllItems.where((item) => item.itemCategory == 'TOP').toList(),
        ItemType.shoes.name: myAllItems.where((item) => item.itemCategory == 'SHOES').toList(),
        ItemType.accessory.name: myAllItems.where((item) => item.itemCategory == 'ACCESSORY').toList(),
        ItemType.bottom.name: myAllItems.where((item) => item.itemCategory == 'BOTTOM').toList(),
        ItemType.hat.name: myAllItems.where((item) => item.itemCategory == 'HAT').toList(),
        ItemType.disposable.name: myAllItems.where((item) => item.itemCategory == 'DISPOSABLE').toList(),
      },
    );
  }

  double get equippedAbrasionRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + (element.itemStat != null ? element.itemStat!.durability! : 0));
  }

  double get equippedRewardRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + (element.itemStat != null ? element.itemStat!.goProfit! : 0)) + equippedBadge.value.badge.rewardRate;
  }

  double get equippedStaminaReduceRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + (element.itemStat != null ? element.itemStat!.stamina! : 0));
  }

  double get equippedLuckRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + (element.itemStat != null ? element.itemStat!.luck! : 0)) + equippedBadge.value.badge.luckRate;
  }

  final RxString itemGoMax = RxString('0');
  final RxString itemDurabilityMax = RxString('0');
  final RxString itemHealthMax = RxString('0');
  final RxString itemLuckMax = RxString('0');
  final RxString badgeGoMax = RxString('0');
  final RxString badgeLuckMax = RxString('0');

  RxDouble progressIndicatorTime = RxDouble(0);

  @override
  void onInit() async {
    await initController();
    progressController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: Duration(seconds: 2),
    );
    super.onInit();
  }

  @override
  void onReady() {
    equippedInfoHeight.value = equippedInfoKey.currentContext != null ? equippedInfoKey.currentContext!.size!.height : 0;
    isLoaded.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    singleChildScrollController.removeListener(() => toggleBottomNav(singleChildScrollController));
    super.onClose();
  }

  Future<void> initController() async {
    initStats();
    getItemMaxValue();
    await getUserAllItems();
    await getUserEquippedItems();
    getSyntheticBadgeList();
    await getUserBadgesList();
    singleChildScrollController.addListener(() {
      toggleBottomNav(singleChildScrollController);
      if (singleChildScrollController.position.pixels == singleChildScrollController.position.maxScrollExtent) {
        onEndScroll();
      }
    });
    calculateTabHeight(0, ItemType.all.name);
    // scrollControl(); // 스크롤 제어(아이템, 뱃지)
  }

  void getItemMaxValue() {
    itemGoMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_go_max');
    itemDurabilityMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_durability_max');
    itemHealthMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_health_max');
    itemLuckMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_luck_max');
    badgeGoMax.value = getConfig(dataType: ConfigType.string, configKey: 'badge_go_max');
    badgeLuckMax.value = getConfig(dataType: ConfigType.string, configKey: 'badge_luck_max');
  }

  Future<void> refreshController() async {
    myAllItems.value = RxList.empty();
    page.value = 0;
    stopLoading.value = false;
    await getUserAllItems();
    await getUserEquippedItems();
    await getUserBadgesList();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [];
  }

  void moveChallengeDetail() {
    if (Get.previousRoute == Routes.challengeDetail) {
      Get.back();
    } else {
      Get.toNamed(Routes.challengeDetail.replaceAll(':id', selectedItem.value.challenge!.challengeId.toString()));
    }
  }

  // void scrollControl() {
  // itemScrollController.addListener(() {
  //   if (itemScrollController.position.atEdge) {
  //     bool isTop = itemScrollController.position.pixels == 0;
  //     // if (isTop) {
  //     //   //print('At the top');
  //     //   singleChildScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  //     // } else {
  //     //   //print('At the bottom');
  //     //   singleChildScrollController.animateTo(singleChildScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  //     // }
  //   }
  // });
  //
  // badgeScrollController.addListener(() {
  //   if (badgeScrollController.position.atEdge) {
  //     bool isTop = badgeScrollController.position.pixels == 0;
  //     // if (isTop) {
  //     //   //print('At the top');
  //     //   singleChildScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  //     // } else {
  //     //   //print('At the bottom');
  //     //   singleChildScrollController.animateTo(singleChildScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  //     // }
  //   }
  // });
  // }

  void initStats() {
    statList.value = [
      StatModel(name: '이동 보상율', currentStat: 78),
      StatModel(name: '행운지수율', currentStat: 78),
    ];
  }

  void toItemDetail(int itemId) async {
    await ItemService.getItemDetailInfo(
      itemId,
      successCallback: (item) {
        selectedItem.value = item;
        isShoe.value = selectedItem.value.itemCategory == 'SHOES';
        if (selectedItem.value.itemCategory == 'SHOES') {
          currentStat.value = selectedItem.value.durability!;
        }
        Get.toNamed(Routes.itemDetail);
      },
    );
  }

  void getItemDetail(int itemId) async {
    await ItemService.getItemDetailInfo(
      itemId,
      successCallback: (item) {
        selectedItem.value = item;
      },
    );
  }

  void toBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badgeId == id);
    setGetBadgeDate(id);
    Get.toNamed(Routes.badgeDetail);
  }

  void getUserAllItemsAfterEquipped() async {
    myAllItems.value = RxList.empty();
    page.value = 0;
    stopLoading.value = false;
    getUserAllItems();
  }

  Future<void> getUserAllItems() async {
    Get.isRegistered<InventoryHomeController>() ? Get.find<InventoryHomeController>() : Get.put(InventoryHomeController());
    dataGetLoading.value = true;
    await ItemService.getAllMyItems(
      page.value,
      successCallback: (List<InventoryItemModel> allItems, int totalItemCount) {
        this.totalItemCount.value = totalItemCount;
        if (allItems.length < 100) {
          stopLoading.value = true;
        }
        myAllItems.value = allItems;
        getUniqueItemList(allItems);
        calculateTabHeight(
            Get.find<InventoryHomeController>().tabController.index, Get.find<InventoryHomeController>().itemSubTabList[Get.find<InventoryHomeController>().subTabController.index]['itemType']!);
        dataGetLoading.value = false;
      },
    );
  }

  Future<void> getUserItemsByCategory(List<Map<String, String>> subTabList, int tabIndex) async {
    String category = subTabList[tabIndex]['itemType']!.toUpperCase();

    dataGetLoading.value = true;
    if (category != 'ALL' && myAllItems.length < totalItemCount.value) {
      await ItemService.getMyItemsByCategory(
        category,
        page.value,
        successCallback: (List<InventoryItemModel> allItemsByCategory) {
          getUniqueItemList(allItemsByCategory);
          if (myAllItems.length == totalItemCount.value) {
            stopLoading.value = true;
          }
          calculateTabHeight(0, subTabList[tabIndex]['itemType']!);
          dataGetLoading.value = false;
        },
      );
    }
  }

  Future<void> getUserEquippedItems() async {
    await ActivityService.getUserEquippedItem(
      successCallback: (equippedItems) {
        equippedItemList.value = equippedItems.items;
        if (equippedItems.badge != null) {
          equippedBadge.update((state) {
            state!.badge.imageUrl = equippedItems.badge!.imageUrl;
            state.badge.rewardRate = equippedItems.badge!.rewardRate;
            state.badge.level = equippedItems.badge!.level;
            state.badge.luckRate = equippedItems.badge!.luckRate;
            state.badge.name = equippedItems.badge!.name;
            state.badge.id = equippedItems.badge!.badgeId;
          });
        } else {
          equippedBadge.update((state) {
            state!.badge.imageUrl = '';
          });
        }

        currentStat.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability;
      },
    );
  }

  void checkEquippedInventoryChallengeItem(int itemId, String category) {
    InventoryItemModel? filteredItem = equippedItemList.firstWhereOrNull((element) => element.itemCategory == category);
    if (filteredItem != null) {
      if (filteredItem.challengeItem != null && filteredItem.challengeItem!) {
        checkChallengeItemEquip(this, itemId);
      } else {
        fetchEquipItem(itemId);
      }
    } else {
      fetchEquipItem(itemId);
    }
  }

  void checkEquippedChallengeItem(bool? isEquippedItem, int itemId) {
    if (isEquippedItem != null && isEquippedItem) {
      checkChallengeItemEquip(this, itemId);
    } else {
      fetchEquipItem(itemId);
    }
  }

  void fetchEquipItem(int itemId) async {
    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) async {
        selectedItem.value = item;
        int allItemsPrevEquippedIndex = myAllItems.indexWhere((element) => element.itemCategory == selectedItem.value.itemCategory && element.equipped!);
        int allItemsIndex = myAllItems.indexWhere((element) => element.id == item.id);
        // int equippedIndex = equippedItemList.indexWhere((element) => element.itemCategory == item.itemCategory);

        if (allItemsPrevEquippedIndex >= 0) {
          myAllItems[allItemsPrevEquippedIndex].equipped = false;
        }

        myAllItems[allItemsIndex] = item;
        // if (equippedIndex > 0) {
        //   equippedItemList[equippedIndex] = item;
        // }

        Timer(const Duration(milliseconds: 500), () {
          getUserEquippedItems();
        });

        // await getUserEquippedItems();
        myAllItems.refresh();
        equippedItemList.refresh();

        showToastPopup('아이템이 장착되었습니다.');
      },
    );
  }

  void fetchEquipBadge(int badgeId) async {
    await ItemService.fetchEquippedBadge(
      badgeId,
      successCallback: (equippedBadgeItem) async {
        equippedBadge.value = equippedBadgeItem;
        await getUserEquippedItems();
        await getUserBadgesList();
        if (selectedBadge.value.badgeId == badgeId) {
          selectedBadge.update((state) {
            state?.state = 'EQUIPPED';
          });
        }

        showToastPopup('뱃지가 장착되었습니다.');
      },
    );
  }

  void setGetBadgeDate(int id) {
    getBadgeDate.value = userBadgesList.firstWhere((item) => item.badgeId == id).issueEndedTime!;
  }

  void toSyntheticBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.id == id);
    Get.toNamed(Routes.syntheticBadge);
  }

  void checkConsumerItemType(InventoryItemModel useItem) async {
    isConsumerItemUsing.value = useItem;
    Adjust.trackEvent(AdjustEvent('scaike'));
    if (useItem.itemStat!.repairDurability! > 0) {
      await fetchRepairShoesUseOneItem(useItem, equippedShoe.value.id);
    } else {
      await fetchRecoveryUseOneItem(useItem);
    }
    await Future.delayed(Duration(milliseconds: 400));
    isConsumerItemUsing.value = null;
    getUserAllItems();
    getUserEquippedItems();
  }

  void initRepairInfo() {
    if (disableButton.value) {
      Timer(const Duration(seconds: 1), () {
        disableButton.value = false;
      });
    }
  }

  void showShoesRepairPopup(int id, context) async {
    isDisableButton.value = true;
    if(Get.currentRoute.contains('home')){
      Adjust.trackEvent(AdjustEvent('d82o3q'));
    } else {
      Adjust.trackEvent(AdjustEvent('j7mhac'));
    }
    await getMyConsumerItemsByType('REPAIR', isNotEmptyCallback: () {
      targetShoeId.value = id;
      selectedType.value = 'DURABILITY';
      currentStat.value = id == equippedShoe.value.id ? equippedShoe.value.durability : selectedItem.value.durability;

      consumerItemUsagePopup(this, context);
    }, isEmptyCallback: () {
      shortConsumerItems(selectedType.value);
    });
    isDisableButton.value = false;
  }

  void confirmRecoveryOrRepairStat(stat) async {
    await fetchRepairShoes();
    getUserAllItems();
    getUserEquippedItems();
    activityController.getUserState();
    if (Get.currentRoute == Routes.itemDetail) {
      getItemDetail(targetShoeId.value);
    }

    initStat();
  }

  void handleNotEnoughTaikaPopup() {
    showNotEnoughTaikaAlert();
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }

  Future<void> onEndScroll() async {
    if (!stopLoading.value) {
      page.value++;
      await getUserAllItems();
    }
  }

  void getUniqueItemList(List<InventoryItemModel> targetList) {
    Set<int> itemSet = myAllItems.map((element) => element.id).toSet();
    List<InventoryItemModel> uniqueItemList = targetList.where((item) => itemSet.add(item.id)).toList();
    myAllItems.value = [...myAllItems, ...uniqueItemList];
    myAllItems.refresh();
  }

  void _calculateListHeight(int listLength) {
    if (listLength > 0) {
      int gridCount = viewportWidth.value < 350 ? 2 : 3;
      int rowCount = (listLength / gridCount).ceil();
      double totalHorizontalPadding = (gridCount - 1) * 10 + 40;
      double itemWidth = (viewportWidth.value - totalHorizontalPadding) / gridCount;
      double itemHeight = itemWidth * 1.5;
      listHeight.value = itemHeight * rowCount + rowCount * 10 + 70;
    } else {
      listHeight.value = 165;
    }
  }

  void calculateTabHeight(int tabIndex, String itemType) {
    switch (tabIndex) {
      case 0:
        _calculateListHeight(allItems[itemType]!.length);
        break;

      case 1:
        _calculateListHeight(userBadgesList.length);
        break;
      default:
        _calculateListHeight(allItems[ItemType.all.name]!.length);
    }
  }

  void moveToExternalBrowser(linkUrl) async {
    Uri url = Uri.parse(linkUrl!);
    if (await canLaunchUrl(url)) {
      await ActivityService.fetchChallengeAllianceLinkRecord(selectedItem.value.challenge!.challengeId, linkUrl);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  int getRemainingDays(String expiryDate) {
    DateTime expiryUTCDateTime = DateTime.parse(expiryDate).toUtc();
    DateTime now = DateTime.now().toUtc();

    return expiryUTCDateTime.difference(now).inDays;
  }
}
