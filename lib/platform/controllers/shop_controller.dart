import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/shop_item_model.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final WalletMasterController walletMasterController = Get.find();

  final RxList<ShopItemModel> shopItemsList = RxList.empty();

  final List<Map<String, String>> sortingList = [
    {'title': '최근 등록 순', 'value': 'Recent'},
    {'title': '높은 가격 순', 'value': 'High'},
    {'title': '낮은 가격 순', 'value': 'Low'}
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

  Rx isSelectedSortValue = Rx({'title': '최근 등록 순', 'value': 'Recent'});
  RxString isSelectedSortString = RxString('최근 등록 순');
  ScrollController singleChildScrollController = ScrollController();
  ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
  RxBool isShortBalance = RxBool(false);
  RxList<ShopItemModel> get sortingShopItemList {
    List<ShopItemModel> itemList = List.empty(growable: true);

    return RxList(itemList);
  }

  Rx<ShopItemModel> selectedItem = Rx(
    ShopItemModel(
      id: -1,
      name: '',
      price: 0,
      itemImageUrl: '',
      itemGrade: '',
      itemCategory: '',
      staminaReduceRate: '',
      durability: '',
      rewardRate: '',
      description: '',
    ),
  );
  @override
  void onInit() {
    initController();

    super.onInit();
  }

  Future<void> initController() async {
    getShopItems();
    scrollControl();
  }

  Future<void> refreshController() async {
    getShopItems();
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
  }

  void toItemDetail(int itemId) async {
    selectedItem.value = shopItemsList.firstWhere((element) => element.id == itemId);
    Get.toNamed(Routes.shopItemDetail);
    // await ItemService.getItemDetailInfo(
    //   itemId,
    //   successCallback: (item) {
    //     selectedItem.value = item;
    //     isShoe.value = selectedItem.value.itemCategory == 'SHOES';
    //     Get.toNamed(Routes.itemDetail);
    //   },
    // );
  }

  void onClickPurchaseItem() {
    if (walletMasterController.tik.value.amount! < selectedItem.value.price) {
      isShortBalance.value = true;
      showTikShortBalancePopup();
    } else {
      showItemPurchasePopup();
    }
  }

  void showItemPurchasePopup() {
    itemPurchaseAlert(this, walletMasterController.tik.value.amount!);
  }

  void showTikShortBalancePopup() {
    itemPurchaseShortBalanceAlert(this, walletMasterController.tik.value.amount!);
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
    print(checkedData);
    isSelectedSortValue.value = checkedData;
  }

  void closeSortingMenu() {
    isSelectedSortValue.value = sortingList[0];
    Get.back();
  }

  void onClickConfirmSortValue(confirmData) {
    isSelectedSortString.value = confirmData['title'];
    Get.back();
  }

  void closeItemPurchasePopup() {
    Get.back();
  }

  void getShopItems() {
    shopItemsList.value = [
      ShopItemModel(
        id: 1,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 2,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description:
            '테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ),
      ShopItemModel(
        id: 1,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 2,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description:
            '테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ),
      ShopItemModel(
        id: 1,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 2,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description:
            '테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ),
      ShopItemModel(
        id: 1,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 2,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description:
            '테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ),
      ShopItemModel(
        id: 1,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 2,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description:
            '테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ),
      ShopItemModel(
        id: 3,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'POOR',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 4,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'LEGEND',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 5,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'EPIC',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 6,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 7,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 8,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 9,
        name: '기본 블루 장갑',
        price: 10004,
        itemImageUrl: 'assets/images/@temp_son.png',
        itemGrade: 'UNCOMMON',
        itemCategory: 'ACCESSORY',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
      ShopItemModel(
        id: 10,
        name: '기본 블루 신발',
        price: 10124,
        itemImageUrl: 'assets/images/@temp_bal.png',
        itemGrade: 'RARE',
        itemCategory: 'SHOES',
        staminaReduceRate: '80-88',
        durability: '80-88',
        rewardRate: '80-88',
        description: '테스트',
      ),
    ];
  }
}
