import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();

  late TabController tabController;
  late TabController subTabController;
  RxInt get containerHeight {
    return RxInt(0);
  }

  late ScrollController scrollController = ScrollController();
  bool fixedScroll = true;
  final RxBool isShoe = RxBool(true);
  List<Map<String, String>> itemSubTabList = [
    {
      'title': '전체',
      'itemType': ItemType.all.name,
    },
    {
      'title': '모자',
      'itemType': ItemType.hat.name,
    },
    {
      'title': '상의',
      'itemType': ItemType.top.name,
    },
    {
      'title': '하의',
      'itemType': ItemType.bottom.name,
    },
    {
      'title': '신발',
      'itemType': ItemType.shoes.name,
    },
    {
      'title': '액세서리',
      'itemType': ItemType.accessory.name,
    },
  ];

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (fixedScroll) {
      scrollController.jumpTo(0);
    }
  }

  void initController() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 6, vsync: this);

    scrollController.addListener(_scrollListener);
  }
}
