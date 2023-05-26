import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/helpers/linear_progress_mixin.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController with LinearProgressMixin, InventoryMixin {
  final WalletMasterController walletMasterController = Get.find();
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
  final RxInt remainDurability = RxInt(0);
  final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);

  final RxDouble currentSliderValue = RxDouble(0);
  final RxBool disableButton = RxBool(false);
  final RxList<InventoryItemModel> equippedItemList = RxList.empty();

  ScrollController singleChildScrollController = ScrollController();
  ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
  ScrollController badgeScrollController = ScrollController(keepScrollOffset: false);

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
  final Rx<RepairShoesModel> shoesDurability = Rx(RepairShoesModel());
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

  Rx<InventoryItemModel> get equippedTop {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'TOP'));
  }

  Rx<InventoryItemModel> get equippedShoe {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'SHOES'));
  }

  Rx<InventoryItemModel> get equippedAccessory {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'ACCESSORY'));
  }

  Rx<InventoryItemModel> get equippedBottom {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'BOTTOM'));
  }

  Rx<InventoryItemModel> get equippedHat {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'HAT'));
  }

  RxMap<String, List<InventoryItemModel>> get allItems {
    return RxMap(
      {
        ItemType.all.name: myAllItems,
        ItemType.top.name: myAllItems.where((item) => item.itemCategory == 'TOP').toList(),
        ItemType.shoes.name: myAllItems.where((item) => item.itemCategory == 'SHOES').toList(),
        ItemType.accessory.name: myAllItems.where((item) => item.itemCategory == 'ACCESSORY').toList(),
        ItemType.drink.name: myAllItems.where((item) => item.itemCategory == 'DRINK').toList(),
        ItemType.bottom.name: myAllItems.where((item) => item.itemCategory == 'BOTTOM').toList(),
        ItemType.hat.name: myAllItems.where((item) => item.itemCategory == 'HAT').toList(),
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

  @override
  void onInit() async {
    await initController();

    super.onInit();
  }

  @override
  void onReady() {
    equippedInfoHeight.value = equippedInfoKey.currentContext!.size!.height;
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
        Get.toNamed(Routes.itemDetail);
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
    dataGetLoading.value = true;
    await ItemService.getAllMyItems(
      page.value,
      successCallback: (List<InventoryItemModel> allItems, int totalItemCount) {
        this.totalItemCount.value = totalItemCount;
        if (allItems.length < 100) {
          stopLoading.value = true;
        }

        getUniqueItemList(allItems);
        calculateTabHeight(0, ItemType.all.name);
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

        remainDurability.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability.floor();
      },
    );
  }

  void checkEquippedInventoryChallengeItem(int itemId, String category) {
    InventoryItemModel filteredItem = equippedItemList.firstWhere((element) => element.itemCategory == category);

    if (filteredItem.challengeItem!) {
      checkChallengeItemEquip(this, itemId);
    } else {
      fetchEquipItem(itemId);
    }
  }

  void checkEquippedChallengeItem(bool? isEquippedItem, int itemId) {
    if (isEquippedItem!) {
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
        int allItemsPrevEquippedIndex = myAllItems.indexWhere((element) => element.itemCategory == item.itemCategory && element.equipped!);
        int allItemsIndex = myAllItems.indexWhere((element) => element.id == item.id);
        int equippedIndex = equippedItemList.indexWhere((element) => element.itemCategory == item.itemCategory);
        myAllItems[allItemsPrevEquippedIndex].equipped = false;
        myAllItems[allItemsIndex] = item;
        equippedItemList[equippedIndex] = item;
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
      successCallback: (equippedBadgeItem) {
        equippedBadge.value = equippedBadgeItem;
        if (selectedBadge.value.badgeId == badgeId) {
          selectedBadge.update((state) {
            state?.state = 'EQUIPPED';
          });
        }
        getUserBadgesList();
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

  void fetchRepairShoes(shoeId) async {
    if (walletMasterController.tik.value.amount! >= costTik.value) {
      if (costTik.value > 0) {
        disableButton.value = true;
        await ItemService.fetchRepairItemShoes(
          RepairShoesModel(
            id: shoeId,
            durability: currentSliderValue.value.toInt(),
            feeTik: costTik.value.toInt(),
          ),
          successCallback: (repairModel) {
            InventoryItemModel newRepairModel = repairModel;
            costTik.value = 0;
            currentSliderValue.value = 0;
            selectedItem.value = newRepairModel;
            remainDurability.value = newRepairModel.durability.toInt();
            walletMasterController.getSpendingWalletBalances();
            getUserAllItems();
            getUserEquippedItems();
            showToastPopup('내구도 충전이 완료되었습니다.');
            closeRepairPopup();
          },
        );
      } else {
        showToastPopup('수리할 내구도가 없습니다.');
      }
    } else {
      handleNotEnoughTaikaPopup();
    }
  }

  void initRepairInfo() {
    costTik.value = 0;
    if (disableButton.value) {
      Timer(const Duration(seconds: 1), () {
        disableButton.value = false;
      });
    }
  }

  void showShoesRepairPopup(id) async {
    currentSliderValue.value = 0;
    await walletMasterController.getFeeTik();
    showShoeRepairSlider(this, walletMasterController.feeTikDurability.value);
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
      double totalPadding = (gridCount - 1) * 10 + 40;
      double itemWidth = (viewportWidth.value - totalPadding) / gridCount;
      double itemHeight = itemWidth * 1.4;
      listHeight.value = itemHeight * rowCount + 70;
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
}
