import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/apis/badge.dart';
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

class InventoryController extends GetxController with LinearProgressMixin {
  final RxList<StatModel> statList = RxList.empty();
  final RxList<InventoryItemModel> myAllItems = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();
  RxList<InventoryBadgeModel> userBadgesList = RxList.empty();
  final RxBool isShoe = RxBool(false);
  RxInt count = 0.obs;
  RxString getBadgeDate = RxString('');
  RxInt remainDurability = RxInt(0);
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
      itemName: '',
      itemCategory: '',
      durability: 0.0,
      abrasionRate: 0.0,
      rewardRate: 0.0,
      staminaReduceRate: 0.0,
      itemImageUrl: '',
      equipped: false,
      listOrder: -1,
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

  Rx<InventoryItemModel> get equippedOuter {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'OUTER'));
  }

  Rx<InventoryItemModel> get equippedShoe {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'SHOES'));
  }

  Rx<InventoryItemModel> get equippedDrink {
    return Rx(equippedItemList.firstWhere((element) => element.itemCategory == 'DRINK'));
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
        'outers': myAllItems.where((item) => item.itemCategory == 'OUTER').toList(),
        'shoes': myAllItems.where((item) => item.itemCategory == 'SHOES').toList(),
        'accessories': myAllItems.where((item) => item.itemCategory == 'ACCESSORY').toList(),
        'drinks': myAllItems.where((item) => item.itemCategory == 'DRINK').toList(),
        'bottoms': myAllItems.where((item) => item.itemCategory == 'BOTTOM').toList(),
        'hats': myAllItems.where((item) => item.itemCategory == 'HAT').toList(),
      },
    );
  }

  @override
  void onInit() {
    once(count, (_) => print('한번만 호출'));
    initStats();
    getUserAllItems();
    getUserEquippedItems();
    getSyntheticBadgeList();
    getUserBadgesList();
    super.onInit();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [];
  }

  void getUserBadgesList() async {
    List<InventoryBadgeModel> badges = await BadgeApi.getUserBadgesList(3);
    userBadgesList.value = badges;
    equippedBadge.value = userBadgesList.firstWhere((item) => item.state == 'EQUIPPED');
  }

  void initStats() {
    statList.value = [
      StatModel(name: '이동 보상율', currentStat: 78),
      StatModel(name: '행운지수율', currentStat: 78),
    ];
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
    remainDurability.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability.floor();
  }

  void fetchEquipBadge(int badgeId) async {
    InventoryBadgeModel equippedBadgeItem = await ItemService.fetchEquippedBadge(badgeId);
    print(equippedBadgeItem);
  }

  void setGetBadgeDate(int id) {
    getBadgeDate.value = userBadgesList.firstWhere((item) => item.badge.id == id).badge.issueEndedTime;
  }

  void toItemDetail(int id) {
    selectedItem.value = myAllItems.firstWhere((item) => item.id == id);
    isShoe.value = selectedItem.value.itemCategory == 'SHOES';
    Get.toNamed(Routes.itemDetail);
  }

  void toSyntheticBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badge.id == id);
    Get.toNamed(Routes.syntheticBadge);
  }

  void fetchRepairShoes() async {
    RepairShoesModel repairModel = await ItemService.fetchRepairItemShoes(
      RepairShoesModel(
        id: selectedItem.value.id,
        durability: 100 - remainDurability.value,
        tik: costTik.toInt(),
      ),
    );
    shoesDurability.value = repairModel;
  }

  void showShoesRepairPopup() {
    _currentSliderValue.value = selectedItem.value.durability.toInt().floor().toDouble();
    Get.dialog(
      AlertDialog(
        title: const Text('내구도 충전'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Durability ${_currentSliderValue.value}/100'),
            Obx(() {
              return Slider(
                value: _currentSliderValue.value,
                max: 100,
                min: 0,
                divisions: 100,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  if (value >= selectedItem.value.durability.toInt().floor()) {
                    _currentSliderValue.value = value;
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
          ElevatedButton(onPressed: () => fetchRepairShoes(), child: const Text('네')),
        ],
      ),
    );
  }

  void closeRepairPopup() {
    Get.back();
  }
}
