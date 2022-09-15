import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late TabController subTabController;
  final RxBool isShoe = RxBool(true);

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 5, vsync: this);
    super.onInit();
  }
}
