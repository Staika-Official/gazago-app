import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaza_go/platform/apis/item.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();
  final RxList<InventoryItemModel> myEquipmentItems = RxList.empty();
  late TabController tabController;
  late TabController subTabController;
  final RxBool isShoe = RxBool(true);
  RxString get staminaReduceRate {
    InventoryItemModel badge = statList.firstWhere((element) => element.itemType == 'BADGE');
    return RxString(badge.staminaReduceRate.toString());
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 5, vsync: this);
    getEquipmentMyItemsList();
    super.onInit();
  }

  void getEquipmentMyItemsList() async {
    const userId = 3;
    List<InventoryItemModel> items = await ExampleService.getMyEquipmentItemsList(userId);
    // myEquipmentItems.add(items);
    inspect(items);
  }
}
