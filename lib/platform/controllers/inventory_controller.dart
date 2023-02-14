import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/helpers/linear_progress_mixin.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController with ScrollMixin, LinearProgressMixin, InventoryMixin {
  final WalletMasterController walletMasterController = Get.find();

  RxInt page = RxInt(0);
  RxBool stopLoading = RxBool(false);
  RxBool dataGetLoading = RxBool(false);

  final RxList<StatModel> statList = RxList.empty();
  final RxList<InventoryItemModel> myAllItems = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();

  final RxBool isShoe = RxBool(false);
  final RxInt count = 0.obs;
  final RxString getBadgeDate = RxString('');
  final RxInt remainDurability = RxInt(0);
  final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);

  final RxDouble currentSliderValue = RxDouble(0);
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
      abrasionRate: 0.0,
      rewardRate: 0.0,
      staminaReduceRate: 0.0,
      itemImageUrl: '',
    ),
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
        'all': myAllItems,
        'outers': myAllItems.where((item) => item.itemCategory == 'TOP').toList(),
        'shoes': myAllItems.where((item) => item.itemCategory == 'SHOES').toList(),
        'accessories': myAllItems.where((item) => item.itemCategory == 'ACCESSORY').toList(),
        'drinks': myAllItems.where((item) => item.itemCategory == 'DRINK').toList(),
        'bottoms': myAllItems.where((item) => item.itemCategory == 'BOTTOM').toList(),
        'hats': myAllItems.where((item) => item.itemCategory == 'HAT').toList(),
      },
    );
  }

  double get equippedAbrasionRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + element.abrasionRate);
  }

  double get equippedRewardRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + element.rewardRate) + equippedBadge.value.badge.rewardRate;
  }

  double get equippedStaminaReduceRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + element.staminaReduceRate);
  }

  @override
  void onInit() async {
    once(count, (_) => print('한번만 호출'));
    await initController();

    super.onInit();
  }

  Future<void> initController() async {
    initStats();
    await getUserAllItems();
    await getUserEquippedItems();
    getSyntheticBadgeList();
    await getUserBadgesList();
    scrollControl(); // 스크롤 제어(아이템, 뱃지)
  }

  Future<void> refreshController() async {
    myAllItems.value = RxList.empty();
    page.value = 0;
    stopLoading.value = false;
    await getUserAllItems();
    await getUserBadgesList();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [];
  }

  void scrollControl() {
    itemScrollController.addListener(() {
      if (itemScrollController.position.atEdge) {
        bool isTop = itemScrollController.position.pixels == 0;
        if (isTop) {
          //print('At the top');
          singleChildScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
        } else {
          //print('At the bottom');
          singleChildScrollController.animateTo(singleChildScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      }
    });

    badgeScrollController.addListener(() {
      if (badgeScrollController.position.atEdge) {
        bool isTop = badgeScrollController.position.pixels == 0;
        if (isTop) {
          //print('At the top');
          singleChildScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
        } else {
          //print('At the bottom');
          singleChildScrollController.animateTo(singleChildScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      }
    });
  }

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
      successCallback: (allItems) {
        // myAllItems.value = allItems;
        if (allItems.length < 100) {
          stopLoading.value = true;
        }
        myAllItems.addAll(allItems);
        dataGetLoading.value = false;
      },
    );
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

  void fetchEquipItem(int itemId) async {
    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) {
        selectedItem.value = item;
        int allItemsPrevEquippedIndex = myAllItems.indexWhere((element) => element.itemCategory == item.itemCategory && element.equipped!);
        int allItemsIndex = myAllItems.indexWhere((element) => element.id == item.id);
        int equippedIndex = equippedItemList.indexWhere((element) => element.itemCategory == item.itemCategory);
        myAllItems[allItemsPrevEquippedIndex].equipped = false;
        myAllItems[allItemsIndex] = item;
        equippedItemList[equippedIndex] = item;
        myAllItems.refresh();
        equippedItemList.refresh();
        // getUserAllItemsAfterEquipped();
        // getUserEquippedItems();
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

  @override
  Future<void> onEndScroll() async {
    if (!stopLoading.value) {
      page.value++;
      await getUserAllItems();
    }
    singleChildScrollController.animateTo(singleChildScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Future<void> onTopScroll() {
    return Future.delayed(
      const Duration(milliseconds: 10),
      () {
        singleChildScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      },
    );
  }
}
