import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/shop_item_model.dart';
import 'package:gaza_go/platform/models/shop_item_purchase_response_model.dart';
import 'package:gaza_go/platform/services/shop_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final WalletMasterController walletMasterController = Get.find();
  LoaderController loaderController = Get.put(LoaderController());
  final RxList<ShopItemModel> shopItemsList = RxList.empty();

  final List<Map<String, String>> sortingList = [
    {'title': '최근 등록 순', 'value': 'id,DESC'},
    // {'title': '높은 가격 순', 'value': 'price,DESC'},
    // {'title': '낮은 가격 순', 'value': 'price,ASC'}
  ];

  final List<Map<String, String>> categoryFilterList = [
    {'title': '모자', 'value': 'HAT'},
    {'title': '하의', 'value': 'BOTTOM'},
    {'title': '상의', 'value': 'TOP'},
    {'title': '신발', 'value': 'SHOES'},
    {'title': '악세사리', 'value': 'ACCESSORY'},
  ];

  final List<Map<String, String>> gradeFilterList = [
    {'title': 'Poor', 'value': 'POOR'},
    {'title': 'Common', 'value': 'COMMON'},
    {'title': 'Uncommon', 'value': 'UNCOMMON'},
    {'title': 'Rare', 'value': 'RARE'},
    {'title': 'Epic', 'value': 'EPIC'},
    {'title': 'Legend', 'value': 'LEGEND'},
  ];

  RxList selectedCategory = RxList.empty(growable: true);
  RxList filteredCategory = RxList.empty(growable: true);

  RxList selectedGrade = RxList.empty(growable: true);
  RxList filteredGrade = RxList.empty(growable: true);

  RxBool isSelectAllItems = RxBool(true);
  RxBool isFilteredItems = RxBool(false);
  RxBool dataGetLoading = RxBool(false);

  Rx isSelectedSortValue = Rx({'title': '최근 등록 순', 'value': 'id,DESC'});
  RxString isSelectedSortString = RxString('최근 등록 순');

  ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
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
    toRewardRate: 0,
    fromRewardRate: 0,
    toAbrasionRate: 0,
    fromAbrasionRate: 0,
    toStaminaReduceRate: 0,
    fromStaminaReduceRate: 0,
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
  void onInit() {
    initController();

    super.onInit();
  }

  Future<void> initController() async {
    getShopItemsList();
    getItemMaxValue();
  }

  Future<void> refreshController() async {
    getShopItemsList();
  }

  void getItemMaxValue() {
    itemGoMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_go_max');
    itemDurabilityMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_durability_max');
    itemHealthMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_health_max');
    itemLuckMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_luck_max');
  }

  void toItemDetail(int itemId) async {
    await ShopService.getShopItemDetails(itemId, successCallback: (ShopItemModel items) {
      selectedItem.value = items;
      print(selectedItem.value);
      Get.toNamed(Routes.shopItemDetail);
    });
  }

  void getItemDetail(int itemId) async {
    await ShopService.getShopItemDetails(itemId, successCallback: (ShopItemModel items) {
      selectedItem.value = items;
    });
  }

  void handlePurchaseShopItem(int itemId) async {
    Get.back();
    loaderController.isLoading.value = true;
    await ShopService.fetchPurchaseShopItem(itemId, successCallback: (ShopItemPurchaseResponseModel items) {
      loaderController.isLoading.value = false;
      purchaseCompleteItem.value = items;
      showItemPurchaseCompletePopup();
      walletMasterController.getSpendingWalletBalances();
      getShopItemsList();
      getItemDetail(itemId);
    }, errorCallback: (statusCode) {
      loaderController.isLoading.value = false;
      if (statusCode == 422) {
        isShortBalance.value = true;
        showTikShortBalancePopup(selectedItem.value.tradeSymbol);
      } else {
        itemPurchaseImpossibleAlert();
      }
    });
  }

  void showItemTip() {
    showItemTipAlert();
  }

  void onClickPurchaseItem(tradeSymbol) {
    if ((tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : walletMasterController.tik.value.amount!) < selectedItem.value.price) {
      isShortBalance.value = true;
      showTikShortBalancePopup(tradeSymbol);
    } else {
      showItemPurchasePopup(tradeSymbol);
    }
  }

  void showItemPurchasePopup(tradeSymbol) {
    itemPurchaseAlert(this, tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.amount!.toString()), tradeSymbol);
  }

  void showTikShortBalancePopup(tradeSymbol) {
    itemPurchaseShortBalanceAlert(
        this, tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.amount!.toString()), tradeSymbol);
  }

  void showItemPurchaseCompletePopup() {
    itemPurchaseCompleteAlert(this);
  }

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
    List newFilteredCategory = [...filteredCategory];
    List newFilteredGrade = [...filteredGrade];
    if (isFilteredItems.value) {
      selectedCategory.value = newFilteredCategory;
      selectedGrade.value = newFilteredGrade;
      isSelectAllItems.value = false;
    } else {
      initItemsFilter();
    }

    Get.back();
  }

  void initItemsFilter() {
    selectedCategory.value = [];
    selectedGrade.value = [];
    isSelectAllItems.value = true;
  }

  void onSelectCategory(category) {
    isSelectAllItems.value = false;
    if (selectedCategory.any((element) => element == category)) {
      selectedCategory.removeWhere((item) => item == category);
    } else {
      selectedCategory.add(category);
    }

    if (selectedCategory.isEmpty && selectedGrade.isEmpty) isSelectAllItems.value = true;
  }

  void onSelectGrade(grade) {
    isSelectAllItems.value = false;
    if (selectedGrade.any((element) => element == grade)) {
      selectedGrade.removeWhere((item) => item == grade);
    } else {
      selectedGrade.add(grade);
    }
    if (selectedCategory.isEmpty && selectedGrade.isEmpty) isSelectAllItems.value = true;
  }

  void onSelectAllItems() {
    initItemsFilter();
    isSelectAllItems.value = true;
  }

  void getShopItemsList() async {
    dataGetLoading.value = true;
    await ShopService.getShopItems(isSelectedSortValue.value['value'], selectedGrade.join(','), selectedCategory.join(','), successCallback: (List<ShopItemModel> items) {
      List newSelectedCategory = [...selectedCategory];
      List newSelectedGrade = [...selectedGrade];
      shopItemsList.value = items;
      if (selectedGrade.join(',') != '' || selectedCategory.join(',') != '') {
        isFilteredItems.value = true;
        filteredCategory.value = newSelectedCategory;
        filteredGrade.value = newSelectedGrade;
      } else {
        isSelectAllItems.value = true;
        isFilteredItems.value = false;
      }

      dataGetLoading.value = false;
    });
  }
}
