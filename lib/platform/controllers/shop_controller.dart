import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/events/replay_event_bus.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/shop_item_model.dart';
import 'package:gaza_go/platform/models/shop_item_purchase_response_model.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/services/shop_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ShopController extends GetxController with GetTickerProviderStateMixin {
  final WalletMasterController walletMasterController = Get.find();

  LoaderController loaderController = Get.put(LoaderController());
  final RxList<ShopItemModel> shopItemsList = RxList.empty();
  late TabController tabController;
  final List<Map<String, String>> sortingList = [
    {'title': 'latest_registration'.tr(), 'value': 'id,DESC'},
    // {'title': 'highest_price'.tr(), 'value': 'price,DESC'},
    // {'title': 'lowest_price'.tr(), 'value': 'price,ASC'}
  ];

  final List<Map<String, String>> categoryFilterList = [
    {'title': 'all'.tr(), 'value': 'ALL'},
    {'title': 'hat'.tr(), 'value': 'HAT'},
    {'title': 'bottom'.tr(), 'value': 'BOTTOM'},
    {'title': 'top'.tr(), 'value': 'TOP'},
    {'title': 'shoes'.tr(), 'value': 'SHOES'},
    {'title': 'accessories_2'.tr(), 'value': 'ACCESSORY'},
    {'title': 'other'.tr(), 'value': 'DISPOSABLE'},
  ];

  final List<Map<String, String>> gradeFilterList = [
    {'title': 'Poor', 'value': 'POOR'},
    {'title': 'Common', 'value': 'COMMON'},
    {'title': 'Uncommon', 'value': 'UNCOMMON'},
    {'title': 'Rare', 'value': 'RARE'},
    {'title': 'Epic', 'value': 'EPIC'},
    {'title': 'Legend', 'value': 'LEGEND'},
  ];

  RxString selectedCategory = RxString('ALL');
  RxList filteredCategory = RxList.empty(growable: true);

  RxList selectedGrade = RxList.empty(growable: true);
  RxList filteredGrade = RxList.empty(growable: true);

  RxBool isSelectAllItems = RxBool(true);
  RxBool isSelectNftItems = RxBool(false);
  RxBool isFilteredItems = RxBool(false);
  RxBool dataGetLoading = RxBool(false);

  Rx isSelectedSortValue =
      Rx({'title': 'latest_registration'.tr(), 'value': 'id,DESC'});
  RxString isSelectedSortString = RxString('latest_registration'.tr());
  RxInt challengeId = RxInt(0);
  ScrollController itemScrollController =
      ScrollController(keepScrollOffset: false);
  RxBool isShortBalance = RxBool(false);

  RxList<ShopItemModel> get sortingShopItemList {
    List<ShopItemModel> itemList = List.empty(growable: true);

    return RxList(itemList);
  }

  Rx<ShopItemModel> selectedItem = Rx(ShopItemModel(
    id: -1,
    name: '',
    itemImageUrl: '',
    itemCategory: '',
    itemGrade: '',
    minGoProfit: 0,
    maxGoProfit: 0,
    minDurability: 0,
    maxDurability: 0,
    minStamina: 0,
    maxStamina: 0,
    minLuck: 0,
    maxLuck: 0,
    price: 0,
    description: '',
  ));

  Rx<ShopItemPurchaseResponseModel> purchaseCompleteItem = Rx(
    ShopItemPurchaseResponseModel(
      id: -1,
      userId: -1,
      serialNumber: '',
      itemName: '',
      itemImageUrl: '',
      itemCategory: '',
      itemGrade: '',
      durability: 0,
      abrasionRate: 0,
      rewardRate: 0,
      staminaReduceRate: 0,
      description: '',
      itemStat: InventoryItemStatModel(
        goProfit: 0.0,
        durability: 0.0,
        stamina: 0.0,
        luck: 0.0,
      ),
    ),
  );

  final RxString itemGoMax = RxString('0');
  final RxString itemDurabilityMax = RxString('0');
  final RxString itemHealthMax = RxString('0');
  final RxString itemLuckMax = RxString('0');

  @override
  void onInit() async {
    initController();

    ReplayEventBus.instance.stream.listen((event) {
      moveToAll();
    });

    super.onInit();
  }

  @override
  void onClose() {
    itemScrollController
        .removeListener(() => toggleBottomNav(itemScrollController));
    super.onClose();
  }

  Future<void> initController() async {
    getShopItemsList();
    getItemMaxValue();
    tabController = TabController(length: 7, vsync: this);
    itemScrollController
        .addListener(() => toggleBottomNav(itemScrollController));
  }

  Future<void> refreshController() async {
    getShopItemsList();
  }

  void moveChallengeDetail() {
    Get.until((route) => Get.currentRoute == Routes.challengeDetail);
    // Get.offNamed(Routes.challengeDetail, arguments: {'id': selectedItem.value.challengeId});
    // if (Get.isRegistered<HomeMenuController>()) {
    //   Get.find<HomeMenuController>().selectMenu(0);
    // } else {
    //   Get.put(HomeMenuController()).selectMenu(0);
    // }
  }

  void getItemMaxValue() {
    itemGoMax.value =
        getConfig(dataType: ConfigType.string, configKey: 'item_go_max');
    itemDurabilityMax.value = getConfig(
        dataType: ConfigType.string, configKey: 'item_durability_max');
    itemHealthMax.value =
        getConfig(dataType: ConfigType.string, configKey: 'item_health_max');
    itemLuckMax.value =
        getConfig(dataType: ConfigType.string, configKey: 'item_luck_max');
  }

  void toItemDetail(int itemId) async {
    Get.toNamed(Routes.shopItemDetail, arguments: {'id': itemId});
  }

  void getItemDetail(int itemId) async {
    await ShopService.getShopItemDetails(itemId,
        successCallback: (ShopItemModel items) {
      selectedItem.value = items;
    });
  }

  void moveToETC() {
    tabController.animateTo(6);
    selectedCategory.value = 'DISPOSABLE';
    initItemsFilter();
    getShopItemsList();
  }

  void moveToAll() {
    print('moveToAll');
    tabController.animateTo(0);
    selectedCategory.value = 'ALL';
    initItemsFilter();
    onSelectNftFilter();
    getShopItemsList();
  }

  // void handlePurchaseShopItem(int itemId) async {
  //   Get.back();
  //   loaderController.isLoading.value = true;
  //   await ShopService.fetchPurchaseShopItem(itemId, successCallback: (ShopItemPurchaseResponseModel items) {
  //     loaderController.isLoading.value = false;
  //     purchaseCompleteItem.value = items;
  //     showItemPurchaseCompletePopup();
  //     walletMasterController.getSpendingWalletBalances();
  //     // print('challengesDetailController :${challengesDetailController.challengeId}');
  //     // if (challengesDetailController.challengeId != 0) {
  //     //   challengesDetailController.refreshController();
  //     // }
  //
  //     getShopItemsList();
  //     getItemDetail(itemId);
  //   }, errorCallback: (statusCode, errorCode, errorMessage) {
  //     loaderController.isLoading.value = false;
  //     if (statusCode == 422) {
  //       isShortBalance.value = true;
  //       showTikShortBalancePopup(selectedItem.value.tradeSymbol);
  //     } else {
  //       if (errorCode == 'PURCHASE_LIMIT_EXCEEDED') {
  //         itemPurchaseAvailableOnlyOneAlert(errorMessage);
  //       } else {
  //         itemPurchaseImpossibleAlert();
  //       }
  //     }
  //   });
  // }

  void fetchEquipItem(int itemId) async {
    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) {
        showToastPopup('item_equipped'.tr());
      },
    );
  }

  void showItemTip() {
    showItemTipAlert();
  }

  // void onClickPurchaseItem(tradeSymbol) {
  //   print(double.parse(walletMasterController.stik.value.uiAmountString!));
  //   print(walletMasterController.tik.value.uiAmountString);
  //   if ((tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.uiAmountString!)) < selectedItem.value.price) {
  //     isShortBalance.value = true;
  //     showTikShortBalancePopup(tradeSymbol);
  //   } else {
  //     showItemPurchasePopup(tradeSymbol);
  //   }
  // }

  // void showItemPurchasePopup(tradeSymbol) {
  //   itemPurchaseAlert(
  //       this, tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.uiAmountString!.toString()), tradeSymbol);
  // }
  //
  // void showTikShortBalancePopup(tradeSymbol) {
  //   itemPurchaseShortBalanceAlert(
  //       this, tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.amount!.toString()), tradeSymbol);
  // }
  //
  // void showItemPurchaseCompletePopup() {
  //   itemPurchaseCompleteAlert(this);
  // }

  void showItemPurchaseImpossiblePopup() {
    itemPurchaseImpossibleAlert();
  }

  void showItemSortingPopup() {
    itemSortListAlert(this);
  }

  void showItemFilterPopup() {
    itemFilterListAlert(this);
  }

  void onClickSortingMenu(checkedData) {
    isSelectedSortValue.value = checkedData;
  }

  void closeSortingMenu() {
    isSelectedSortValue.value = sortingList[0];
    Get.back();
  }

  void onClickConfirmSortValue(confirmData) {
    isSelectedSortString.value = confirmData['title'];
    getShopItemsList();
    Get.back();
  }

  void onClickConfirmFilterValue() {
    getShopItemsList();
    Get.back();
  }

  void closeItemPurchasePopup() {
    Get.back();
  }

  void closeItemFilterPopup() {
    // List newFilteredCategory = [...filteredCategory];
    List newFilteredGrade = [...filteredGrade];
    if (isFilteredItems.value) {
      // selectedCategory.value = newFilteredCategory;
      selectedGrade.value = newFilteredGrade;
      isSelectAllItems.value = false;
      isSelectNftItems.value = false;
    } else {
      initItemsFilter();
    }

    Get.back();
  }

  void initItemsFilter() {
    filteredGrade.clear();
    selectedGrade.clear();
    isSelectAllItems.value = true;
    isSelectNftItems.value = false;
  }

  void onSelectCategory(category) {
    selectedCategory.value = category;
    getShopItemsList();
  }

  void onSelectGrade(grade) {
    isSelectAllItems.value = false;
    isSelectNftItems.value = false;

    if (selectedGrade.any((element) => element == grade)) {
      selectedGrade.removeWhere((item) => item == grade);
    } else {
      selectedGrade.add(grade);
    }
    if (selectedCategory.value == 'ALL' && selectedGrade.isEmpty) {
      isSelectAllItems.value = true;
      isSelectNftItems.value = false;
    }
  }

  void onSelectAllItems() {
    initItemsFilter();
    isSelectAllItems.value = true;
    isSelectNftItems.value = false;
  }

  void onSelectNftFilter() {
    initItemsFilter();
    isSelectAllItems.value = false;
    isSelectNftItems.value = true;
  }

  void getShopItemsList() async {
    dataGetLoading.value = true;
    await ShopService.getShopItems(
      isSelectedSortValue.value['value'],
      selectedGrade.join(','),
      selectedCategory.value == 'ALL' ? '' : selectedCategory.value,
      isSelectNftItems.value ? 'NFT' : null,
      successCallback: (List<ShopItemModel> items) {
        // List newSelectedCategory = [...selectedCategory];
        List newSelectedGrade = [...selectedGrade];
        shopItemsList.value = items;
        if (selectedGrade.join(',') != '') {
          isFilteredItems.value = true;
          // filteredCategory.value = newSelectedCategory;
          filteredGrade.value = newSelectedGrade;
        } else if (isSelectNftItems.value) {
          filteredGrade.clear();
          isSelectAllItems.value = false;
          isFilteredItems.value = true;
        } else {
          filteredGrade.clear();
          isSelectAllItems.value = true;
          isFilteredItems.value = false;
        }

        dataGetLoading.value = false;
      },
    );
  }
}
