import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/models/wallet_item_model.dart';
import 'package:step_go/presentations/components/main_appbar.dart';
import 'package:step_go/presentations/components/secondary_appbar.dart';
import 'package:step_go/presentations/views/activity/index.dart';
import 'package:step_go/presentations/views/archive/index.dart';
import 'package:step_go/presentations/views/inventory/inventory_item_detail.dart';
import 'package:step_go/presentations/views/leaderboard/index.dart';
import 'package:step_go/presentations/views/shop/index.dart';

class HomeMenuController extends GetxController {
  final RxList<WalletItemModel> walletList = RxList.empty();
  final RxInt selectedIndex = RxInt(2);

  final List<PreferredSizeWidget> appbarList = [
    MainAppbar(),
    SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    ArchiveHome(),
    // InventoryHome(),
    InventoryItemDetail(),
    ActivityHome(),
    ShopHome(),
    LeaderboardHome(),
  ];

  PreferredSizeWidget get appbar {
    return selectedIndex.value == 2 ? appbarList.first : appbarList.last;
  }

  @override
  void onInit() {
    getWalletList();
    super.onInit();
  }

  void getWalletList() {
    walletList.value = [
      WalletItemModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      WalletItemModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      WalletItemModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }

  void selectMenu(int index) {
    selectedIndex.value = index;
  }
}
