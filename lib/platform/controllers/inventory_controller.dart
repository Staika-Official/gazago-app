import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/helpers/linear_progress_mixin.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController with LinearProgressMixin, InventoryMixin {
  final WalletMasterController walletMasterController = Get.find();

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
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badgeId == id);
    setGetBadgeDate(id);
    Get.toNamed(Routes.badgeDetail);
  }

  void getUserAllItems() async {
    List<InventoryItemModel> allItems = await ItemService.getAllMyItems();
    // List<InventoryItemModel> test = List.empty(growable: true);
    // for (int i = 0; i < 10; i++) {
    //   test.add(allItems[0]);
    // }
    myAllItems.value = allItems;
  }

  void getUserEquippedItems() async {
    EquippedItemModel equippedItems = await ActivityService.getUserEquippedItem();
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
        state!.badge.imageUrl = 'assets/images/@temp_badge.png';
      });
    }

    remainDurability.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability.floor();
  }

  void fetchEquipItem(int itemId) async {
    InventoryItemModel equippedItem = await ItemService.fetchEquippedItem(itemId);
    getUserAllItems();
    getUserEquippedItems();
    showToastPopup('아이템이 장착되었습니다.');
  }

  void fetchEquipBadge(int badgeId) async {
    InventoryBadgeModel equippedBadgeItem = await ItemService.fetchEquippedBadge(badgeId);
    equippedBadge.value = equippedBadgeItem;
    getUserBadgesList();
    showToastPopup('뱃지가 장착되었습니다.');
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
        InventoryItemModel repairModel = await ItemService.fetchRepairItemShoes(
          RepairShoesModel(
            id: shoeId,
            durability: _currentSliderValue.value.toInt(),
            feeTik: costTik.value.toInt(),
          ),
        );

        costTik.value = 0;
        _currentSliderValue.value = 0;
        selectedItem.value = repairModel;
        remainDurability.value = repairModel.durability.toInt();
        walletMasterController.getSpendingWalletBalances();
        getUserAllItems();
        getUserEquippedItems();
        showToastPopup('내구도 충전이 완료되었습니다.');
        closeRepairPopup();
      } else {
        showToastPopup('수리할 내구도가 없습니다.');
      }
    } else {}
  }

  void initRepairInfo() {
    costTik.value = 0;
  }

  void showShoesRepairPopup(id) {
    _currentSliderValue.value = 0;

    Get.bottomSheet(
      Obx(() {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xff363841),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StyledText(
                      '내구도 충전하기',
                      fontSize: 22,
                      lineHeight: 22,
                      fontWeight: 500,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: StyledText(
                        '현재 신발 내구도 ${equippedShoe.value.durability.toInt()}',
                        fontSize: 16,
                        lineHeight: 22,
                        fontWeight: 500,
                        color: const Color(0xFF8A8A8A),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: FlutterSlider(
                        values: [_currentSliderValue.value],
                        max: 100,
                        min: 0,
                        handlerHeight: 32.0,
                        ignoreSteps: [
                          FlutterSliderIgnoreSteps(from: 0, to: 0),
                        ],
                        trackBar: FlutterSliderTrackBar(
                          inactiveTrackBarHeight: 16,
                          activeTrackBarHeight: 15,
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF494954),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFB85DFF),
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _currentSliderValue.value = lowerValue;
                          costTik.value = _currentSliderValue.value.toInt() * 100;
                        },
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(
                            color: Color(0xFFB85DFF),
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          child: iconSliderShoe,
                        ),
                        tooltip: FlutterSliderTooltip(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                          format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
                          boxStyle: FlutterSliderTooltipBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFB85DFF),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const StyledText(
                            '비용 :',
                            fontSize: 22,
                            fontWeight: 500,
                            color: Color(0xFFA7A7A7),
                          ),
                          StyledText(
                            ' ${costTik.value} TIK',
                            fontSize: 22,
                            fontWeight: 500,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GazagoButton(
                            onTap: () => closeRepairPopup(),
                            buttonText: '취소',
                            textColor: Colors.white,
                            buttonColor: const Color(0xFF363841),
                          ),
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Expanded(
                          child: GazagoButton(
                            onTap: () => fetchRepairShoes(equippedShoe.value.id),
                            buttonText: '네',
                            buttonColor: const Color(0xFF0EE6F3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }
}
