import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/inventory_item_stat_model.dart';
import 'package:gaza_go/platform/models/shop_item_model.dart';
import 'package:gaza_go/platform/models/shop_item_purchase_response_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/services/shop_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/enums.dart';

class ShopDetailController extends GetxController {
  final WalletMasterController walletMasterController = Get.find();
  final HomeMenuController homeMenuController = Get.put(HomeMenuController());
  ShopController shopController = Get.isRegistered<ShopController>() ? Get.find<ShopController>() : Get.put(ShopController());
  ChallengesDetailController challengesDetailController = Get.isRegistered<ChallengesDetailController>() ? Get.find<ChallengesDetailController>() : Get.put(ChallengesDetailController());
  LoaderController loaderController = Get.put(LoaderController());
  final RxList<ShopItemModel> shopItemsList = RxList.empty();
  final RxInt purchaseItemCount = RxInt(1);

  RxInt get purchaseItemSumPrice {
    return RxInt((purchaseItemCount.value * selectedItem.value.price).toInt());
  }

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
  RxInt itemId = RxInt(0);
  ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
  RxBool isShortBalance = RxBool(false);

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
    itemId.value = await Get.arguments['id'];
    initController();

    super.onInit();
  }

  @override
  void onClose() {
    itemScrollController.removeListener(() => toggleBottomNav(itemScrollController));
    shopController.getShopItemsList();


    if(Get.previousRoute.contains('challenge_detail')){
      challengesDetailController.refreshController();
    }
    super.onClose();
  }

  Future<void> initController() async {
    getItemDetail(itemId.value);
    getItemMaxValue();
    itemScrollController.addListener(() => toggleBottomNav(itemScrollController));
  }

  Future<void> refreshController() async {}

  void moveChallengeDetail() {
    if (Get.previousRoute == Routes.challengeDetail) {
      Get.back();
    } else {
      Get.toNamed(Routes.challengeDetail.replaceAll(':id', selectedItem.value.challengeId.toString()));
    }
  }

  void getItemMaxValue() {
    itemGoMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_go_max');
    itemDurabilityMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_durability_max');
    itemHealthMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_health_max');
    itemLuckMax.value = getConfig(dataType: ConfigType.string, configKey: 'item_luck_max');
  }

  void getItemDetail(int itemId) async {
    await ShopService.getShopItemDetails(itemId, successCallback: (ShopItemModel items) {
      selectedItem.value = items;

      // Get.toNamed(Routes.shopItemDetail);
    });
  }

  void handlePurchaseShopItem(int itemId) async {
    Get.back();
    int itemCount = selectedItem.value.itemCategory == 'DISPOSABLE' ? purchaseItemCount.value : 1;
    loaderController.isLoading.value = true;
    await ShopService.fetchPurchaseShopItem(itemId, itemCount, successCallback: (ShopItemPurchaseResponseModel items) {
      loaderController.isLoading.value = false;
      purchaseCompleteItem.value = items;

      showItemPurchaseCompletePopup();
      walletMasterController.getSpendingWalletBalances();
      shopController.getShopItemsList();
      getItemDetail(itemId);
    }, errorCallback: (errorData) {
      loaderController.isLoading.value = false;
      if (errorData.status == 422) {
        isShortBalance.value = true;
        showTikShortBalancePopup(selectedItem.value.tradeSymbol);
      } else {
        if (errorData.errorCode == 'PURCHASE_LIMIT_EXCEEDED') {
          itemPurchaseAvailableOnlyOneAlert(errorData.errorMessage);
        } else {
          itemPurchaseImpossibleAlert();
        }
      }
    });
  }

  void fetchEquipItem(int itemId) async {
    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) {
        showToastPopup('아이템이 장착되었습니다.');
        if (Get.isRegistered<ChallengesDetailController>() && Get.find<ChallengesDetailController>().challengeId.value != 0) {
          Get.find<ChallengesDetailController>().getChallengeDetail();
        }
      },
    );
  }

  void showItemTip() {
    showItemTipAlert();
  }


  void handleCheckPurchaseAvailable(tradeSymbol){
    if ((tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.uiAmountString!)) <
        (selectedItem.value.itemCategory == 'DISPOSABLE' ? purchaseItemSumPrice.value : selectedItem.value.price)) {
      isShortBalance.value = true;
      showTikShortBalancePopup(tradeSymbol);
    } else {
      showItemPurchasePopup(tradeSymbol);
    }
  }

  Future<void> onClickPurchaseItem(tradeSymbol) async {
    purchaseItemCount.value = 1;

    if(selectedItem.value.challengeId != null){
      await UaaService.getAccountInfo(
        successCallback: (UserAccountModel user) {
          if (user.authorities!.contains('ROLE_CERTIFIED_USER')) {
            handleCheckPurchaseAvailable(tradeSymbol);
          } else {
            showChallengeItemBuyNeedVerificationAlert();
          }
        },
      );
    } else {
      handleCheckPurchaseAvailable(tradeSymbol);
    }
  }



  void showItemPurchasePopup(tradeSymbol) {
    itemPurchaseAlert(
        this, tradeSymbol == 'STIK' ? double.parse(walletMasterController.stik.value.uiAmountString!) : double.parse(walletMasterController.tik.value.uiAmountString!.toString()), tradeSymbol);
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

  void closeItemPurchasePopup() {
    Get.back();
  }

  void moveToExternalBrowser(linkUrl) async {
    Uri url = Uri.parse(linkUrl!);
    if (await canLaunchUrl(url)) {
      await ActivityService.fetchChallengeAllianceLinkRecord(selectedItem.value.challenge!.challengeId, linkUrl);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
