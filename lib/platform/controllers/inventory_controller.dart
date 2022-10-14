import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/helpers/linear_progress_mixin.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController with LinearProgressMixin, InventoryMixin {
  final WalletMasterController? walletMasterController;

  InventoryController([this.walletMasterController]);

  final RxList<StatModel> statList = RxList.empty();
  final RxList<InventoryItemModel> myAllItems = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();

  final RxBool isShoe = RxBool(false);
  RxInt count = 0.obs;
  RxString getBadgeDate = RxString('');
  RxInt remainDurability = RxInt(0);
  RxInt repairDurability = RxInt(0);
  RxInt costTik = RxInt(0);

  final RxDouble _currentSliderValue = RxDouble(0);
  RxList<InventoryItemModel> equippedItemList = RxList.empty();

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
  Rx<InventoryBadgeModel> selectedBadge = Rx(
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
        'outers': myAllItems.where((item) => item.itemCategory == 'OUTER').toList(),
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
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + element.rewardRate);
  }

  double get equippedStaminaReduceRate {
    return equippedItemList.fold(0.0, (summedValue, element) => summedValue + element.staminaReduceRate);
  }

  @override
  void onInit() {
    once(count, (_) => print('한번만 호출'));
    initController();

    super.onInit();
  }

  Future<void> initController() async {
    initStats();
    getUserAllItems();
    getUserEquippedItems();
    getSyntheticBadgeList();
    getUserBadgesList();
  }

  Future<void> refreshController() async {
    getUserAllItems();
    getUserBadgesList();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [];
  }

  void initStats() {
    statList.value = [
      StatModel(name: '이동 보상율', currentStat: 78),
      StatModel(name: '행운지수율', currentStat: 78),
    ];
  }

  void toItemDetail(int itemId) async {
    InventoryItemModel item = await ItemService.getItemDetailInfo(itemId);
    selectedItem.value = item;
    isShoe.value = selectedItem.value.itemCategory == 'SHOES';
    Get.toNamed(Routes.itemDetail);
  }

  void toBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badge.id == id);
    setGetBadgeDate(id);
    Get.toNamed(Routes.badgeDetail);
  }

  void getUserAllItems() async {
    List<InventoryItemModel> allItems = await ItemService.getAllMyItems();
    myAllItems.value = allItems;
  }

  void getUserEquippedItems() async {
    EquippedItemModel equippedItems = await ActivityService.getUserEquippedItem();
    equippedItemList.value = equippedItems.items;
    if (equippedItems.badge != null) {
      equippedBadge.update((state) {
        state!.badge.imageUrl = equippedItems.badge!.imageUrl;
      });
    } else {
      equippedBadge.update((state) {
        state!.badge.imageUrl = 'assets/images/@temp_badge.png';
      });
    }
    remainDurability.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability.floor();
  }

  void fetchEquipItem(int itemId) async {
    InventoryItemModel equippedItem = await ItemService.fetchEquippedItem(itemId);
    print(equippedItem);
  }

  void fetchEquipBadge(int badgeId) async {
    InventoryBadgeModel equippedBadgeItem = await ItemService.fetchEquippedBadge(badgeId);
    equippedBadge.value = equippedBadgeItem;
  }

  void setGetBadgeDate(int id) {
    getBadgeDate.value = userBadgesList.firstWhere((item) => item.badge.id == id).badge.issueEndedTime;
  }

  void toSyntheticBadgeDetail(int id) {
    print(id);
    inspect(userBadgesList);
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badge.id == id);
    Get.toNamed(Routes.syntheticBadge);
  }

  void fetchRepairShoes(shoeId) async {
    print(repairDurability.value);
    if (costTik.value > 0) {
      InventoryItemModel repairModel = await ItemService.fetchRepairItemShoes(
        RepairShoesModel(
          id: shoeId,
          durability: repairDurability.value,
          feeTik: costTik.value.toInt(),
        ),
      );

      print(repairModel);
      costTik.value = 0;
      selectedItem.value = repairModel;
      remainDurability.value = repairModel.durability.toInt();
      closeRepairPopup();
    } else {
      print('수리할 내구도가 없습니다.');
    }
  }

  void initRepairInfo() {
    costTik.value = 0;
  }

  void showShoesRepairPopup(id) {
    _currentSliderValue.value = equippedShoe.value.durability.toInt().floor().toDouble();

    Get.dialog(
      AlertDialog(
        title: const Text('내구도 충전'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text('Durability ${_currentSliderValue.value.toStringAsFixed(0)}/100');
            }),
            Obx(() {
              return Slider(
                value: _currentSliderValue.value < 0 ? 0 : _currentSliderValue.value,
                max: 100,
                min: 0,
                divisions: 100,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  if (value >= equippedShoe.value.durability.toInt().floor()) {
                    _currentSliderValue.value = value;
                    repairDurability.value = (value - equippedShoe.value.durability.floor()).toInt();
                    costTik.value = (value.toInt() - remainDurability.value).abs() * 100;
                  }
                },
              );
            }),
            Obx(() {
              return Text('비용: ${costTik.value} TIK');
            }),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => closeRepairPopup(), child: const Text('아니요')),
          ElevatedButton(onPressed: () => fetchRepairShoes(equippedShoe.value.id), child: const Text('네')),
        ],
      ),
    );
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }
}
