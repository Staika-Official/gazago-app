import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();

  late TabController tabController;
  late TabController subTabController;
  final RxBool isShoe = RxBool(true);
  List itemSubTabList = [
    {
      'title': '전체',
      'itemType': 'all',
    },
    {
      'title': '모자',
      'itemType': 'hats',
    },
    {
      'title': '상의',
      'itemType': 'outers',
    },
    {
      'title': '하의',
      'itemType': 'bottoms',
    },
    {
      'title': '신발',
      'itemType': 'shoes',
    },
    {
      'title': '액세서리',
      'itemType': 'accessories',
    },
  ];

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  void initController() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 6, vsync: this);
  }
}
