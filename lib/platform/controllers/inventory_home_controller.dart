import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class InventoryHomeController extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();

  late TabController tabController;
  late TabController subTabController;

  List<Map<String, String>> itemSubTabList = [
    {
      'title': 'all'.tr(),
      'itemType': ItemType.all.name,
    },
    {
      'title': 'hat'.tr(),
      'itemType': ItemType.hat.name,
    },
    {
      'title': 'top'.tr(),
      'itemType': ItemType.top.name,
    },
    {
      'title': 'bottom'.tr(),
      'itemType': ItemType.bottom.name,
    },
    {
      'title': 'shoes'.tr(),
      'itemType': ItemType.shoes.name,
    },
    {
      'title': 'accessories'.tr(),
      'itemType': ItemType.accessory.name,
    },
    {
      'title': 'other'.tr(),
      'itemType': ItemType.disposable.name,
    },
  ];

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.animateTo(0);
    // tabController.dispose();
    subTabController.dispose();

    super.onClose();
  }

  void initController() {
    tabController = TabController(length: 2, vsync: this);
    subTabController = TabController(length: 7, vsync: this);

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        Get.find<InventoryController>().calculateTabHeight(tabController.index,
            itemSubTabList[subTabController.index]['itemType']!);
      }
    });

    subTabController.addListener(() {
      if (subTabController.indexIsChanging) {
        Get.find<InventoryController>().calculateTabHeight(tabController.index,
            itemSubTabList[subTabController.index]['itemType']!);
      }
    });
  }
}
