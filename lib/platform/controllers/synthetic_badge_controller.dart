import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:get/get.dart';

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

  List<Widget> _getListWidgets(List<InventoryBadgeModel> list) {
    return list
        .map(
          (badge) => InkWell(
            onTap: () => null,
            child: Image(
              image: AssetImage(badge.badgeImageUrl),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
        )
        .toList();
  }

  void showSelectBadgePopup(List<InventoryBadgeModel> badgeItems) {
    selectedBadge.value = List<InventoryBadgeModel>.from(badgeItems).first;
    myBadgeList.value = List<InventoryBadgeModel>.from(badgeItems);
    developer.log(jsonEncode(selectedBadge));
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Container(
          child: Column(
            children: [
              Center(child: Image.asset(selectedBadge.value.badgeImageUrl)),
              SizedBox(
                width: 200,
                height: 400,
                child: Obx(() {
                  return GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 4,
                    children: [..._getListWidgets(myBadgeList)],
                  );
                }),
              ),
            ],
          ),
        ),
        // child: GridView.count(
        //   primary: false,
        //   padding: const EdgeInsets.all(20),
        //   crossAxisSpacing: 10,
        //   mainAxisSpacing: 10,
        //   crossAxisCount: 4,
        //   children: <Widget>[
        //     SingleChildScrollView(
        //       physics: ClampingScrollPhysics(),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [..._getListWidgets(myBadgeList)],
        //       ),
        //     ),
        //   ],
        // ),

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
