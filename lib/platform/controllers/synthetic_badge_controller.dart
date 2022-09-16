import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/models/inventory_badge_model.dart';

class SyntheticBadgeController extends GetxController {
  RxList<InventoryBadgeModel> selectedBadgeList = RxList.empty();

  @override
  void onInit() {
    super.onInit();
  }

  void showSelectBadgePopup() {
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Container(
          child: Text('사용 중인 계정이 다른 기기에서.\n접속이 종료 되었습니다.?'),
        ),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('취소')),
          ElevatedButton(onPressed: () => Get.back(), child: const Text('확인')),
        ],
      ),
    );
  }
}
