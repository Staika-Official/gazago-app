import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:get/get.dart';

class SyntheticBadgeController extends GetxController {
  InventoryBadgeModel prevSelectedBadge;
  SyntheticBadgeController(this.prevSelectedBadge);

  RxList<InventoryBadgeModel> selectedBadgeList = RxList.empty();
  RxList<InventoryBadgeModel> myBadgeList = RxList.empty();
  RxString selectedBadgeType = RxString('');
  RxList<String> get selectedBadgeImages {
    RxList<String> images = RxList.empty();
    for (int i = 0; i < 5; i++) {
      if (selectedBadgeList.length > i) {
        images.add(selectedBadgeList[i].badge.imageUrl);
      } else {
        images.add('');
      }
    }
    return images;
  }

  RxString get badgeType {
    switch (selectedBadgeType.value) {
      case 'HIKING':
        return RxString('등산');
      case 'MISSION':
        return RxString('미션');
      case 'COMPOSE':
        return RxString('합성');
    }
    return RxString('');
  }

  Rx<InventoryBadgeModel> selectedBadge = Rx(
    InventoryBadgeModel(
        id: -1,
        userId: -1,
        state: '',
        createdBy: '',
        createdDate: '',
        lastModifiedBy: '',
        lastModifiedDate: '',
        badge: InventoryBadgeItemModel(
            id: -1,
            level: 0,
            rewardRate: 0.0,
            luckRate: 0.0,
            source: '',
            issueType: '',
            issueState: '',
            issueStartedTime: '',
            issueEndedTime: '',
            description: '',
            state: '',
            address: '',
            imageUrl: 'imageUrl',
            createdBy: 'createdBy',
            createdDate: 'createdDate',
            lastModifiedBy: 'lastModifiedBy',
            lastModifiedDate: 'lastModifiedDate')),
  );
  final RxInt selectBadgeId = RxInt(0);

  @override
  void onReady() {
    selectedBadgeType.value = prevSelectedBadge.badge.issueType;
    selectedBadgeList.add(prevSelectedBadge);
    super.onReady();
  }

  List<Widget> _getListWidgets(List<InventoryBadgeModel> list) {
    return list
        .asMap()
        .entries
        .map(
          (badge) => InkWell(
            onTap: () => selectItem(badge.value, badge.value.id),
            child: Container(
              child: Stack(
                children: [
                  Image(
                    image: CachedNetworkImageProvider(badge.value.badge.imageUrl),
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                  if (selectedBadge.value.id == badge.value.id)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Icon(Icons.check, size: 20),
                    ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  void showSelectBadgePopup(List<InventoryBadgeModel> badgeItems, index) {
    selectedBadge.value = List<InventoryBadgeModel>.from(badgeItems).first;
    myBadgeList.value = List<InventoryBadgeModel>.from(badgeItems);

    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Obx(() {
          return Container(
            child: Column(
              children: [
                Center(
                    child: Image(
                  image: CachedNetworkImageProvider(selectedBadge.value.badge.imageUrl),
                )),
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
          );
        }),
        actions: [
          ElevatedButton(onPressed: () => closeSelectBadge(), child: const Text('취소')),
          ElevatedButton(onPressed: () => selectedItemAddedList(), child: const Text('확인')),
        ],
      ),
    );
  }

  void selectItem(InventoryBadgeModel badge, badgeId) {
    selectedBadge.value = badge;
    selectBadgeId.value = badgeId;

    // myBadgeList.removeWhere((element) => element.id == badge.id);
  }

  void selectedItemAddedList() {
    selectedBadgeList.add(selectedBadge.value);
    myBadgeList.removeWhere((element) => element.id == selectBadgeId);
    Get.back();
  }

  void syntheticBadgeConfirm() {}

  void closeSelectBadge() {
    Get.back();
  }
}
