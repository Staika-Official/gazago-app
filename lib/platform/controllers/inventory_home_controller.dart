import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:get/get.dart';

class InventoryHomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<InventoryItemModel> statList = RxList.empty();

  late TabController tabController;
  late TabController subTabController;

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
    {
      'title': '기타',
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
        Get.find<InventoryController>().calculateTabHeight(tabController.index, itemSubTabList[subTabController.index]['itemType']!);
      }
    });

    subTabController.addListener(() {
      if (subTabController.indexIsChanging) {
        Get.find<InventoryController>().calculateTabHeight(tabController.index, itemSubTabList[subTabController.index]['itemType']!);
      }
    });
  }
}
