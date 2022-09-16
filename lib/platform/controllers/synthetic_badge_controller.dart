import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/models/inventory_badge_model.dart';

class SyntheticBadgeController extends GetxController {
  RxList<InventoryBadgeModel> selectedBadgeList = RxList.empty();
  RxList<InventoryBadgeModel> myBadgeList = RxList.empty();

  Rx<InventoryBadgeModel> selectedBadge = Rx(InventoryBadgeModel(
    id: 1,
    badgeImageUrl: 'assets/images/@temp_badge.png',
    badgeName: '소래산 등정 뱃지',
    effect: 3,
    getDate: '2022.08.29',
    level: 1,
    moveCompensationRate: 15,
    luckyRate: 20,
  ));
  final RxInt selectBadgeIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  void showSelectBadgePopup(List<InventoryBadgeModel> badgeItems) {
    selectedBadge.value = List<InventoryBadgeModel>.from(badgeItems)[0];
    myBadgeList.value = List<InventoryBadgeModel>.from(badgeItems);

    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Container(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: <Widget>[
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...myBadgeList
                        .map(
                          (element) => Text(element.badgeName),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('취소')),
          ElevatedButton(onPressed: () => Get.back(), child: const Text('확인')),
        ],
      ),
    );
  }

  void selectItem(InventoryBadgeModel badge) {
    selectedBadge.value = badge;
    selectedBadgeList.add(myBadgeList.firstWhere((element) => element.id == badge.id));
    myBadgeList.removeWhere((element) => element.id == badge.id);
  }
}
