import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();

  late TabController tabController;
  late TabController subTabController;
  final RxBool isShoe = RxBool(true);

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  void initController() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 5, vsync: this);
  }
}
