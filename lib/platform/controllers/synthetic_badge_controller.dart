import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:get/get.dart';

class SyntheticBadgeController extends GetxController with InventoryMixin {
  Rx<InventoryBadgeModel> selectedBadgePrev;
  SyntheticBadgeController(this.selectedBadgePrev);

  late RxList<InventoryBadgeModel?> selectedBadgeList = RxList<InventoryBadgeModel?>.filled(selectedBadgeLevel.value, null);
  RxList selectedBadgeIdList = RxList.empty();
  RxList<InventoryBadgeModel> myBadgeList = RxList.empty();
  // RxList<InventoryBadgeModel> selectedBadgeList = RxList.empty();
  RxInt get selectedBadgeLevel {
    return RxInt(selectedBadgePrev.value.badge.level == 1 ? 5 : 2);
  }

  RxString selectedBadgeType = RxString('');
  RxList<String> get selectedBadgeImages {
    RxList<String> images = RxList.empty();
    for (int i = 0; i < selectedBadgeLevel.value; i++) {
      if (selectedBadgeList.length > i) {
        images.add(selectedBadgeList[i]!.badge.imageUrl);
      } else {
        images.add('');
      }
    }
    return images;
  }

  RxString get badgeType {
    switch (selectedBadgePrev.value.badge.issueType) {
      case 'HIKING':
        return RxString('등산');
      case 'MISSION':
        return RxString('미션');
      case 'COMPOSE':
        return RxString('합성');
    }
    return RxString('');
  }

  Rx<InventoryBadgeModel> selectBadge = Rx(
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
  final RxInt selectBadgeIndex = RxInt(0);
  RxInt feeTik = RxInt(0);

  RxInt get syntheticBadgeFee {
    return RxInt(selectedBadgeList.fold(0, (prevValue, element) => prevValue + element!.badge.level));
  }

  @override
  void onInit() {
    getUserBadgesList();

    super.onInit();
  }

  @override
  void onReady() {
    selectedBadgeType.value = selectedBadgePrev.value.badge.issueType;
    selectedBadgeList[0] = (selectedBadgePrev.value);
    selectedBadgeIdList.add(selectedBadgePrev.value.badge.id);

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
                  Text(badge.value.badge.id.toString()),
                  // Image(
                  //   image: CachedNetworkImageProvider(selectBadge.value.badge.imageUrl),
                  //   fit: BoxFit.fill,
                  //   width: double.infinity,
                  // ),
                  if (selectBadge.value.id == badge.value.id)
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

  void showSelectBadgePopup(List<InventoryBadgeModel> badgeItems, selectedBadgeItem, index) {
    print(index);
    // selectedBadgeList[index] =
    userBadgesList.removeWhere((element) => element.id == selectedBadgePrev.value.id);
    if (selectedBadgePrev.value.badge.level >= 5) {
      userBadgesList.removeWhere((element) => element.badge.level < 5);
    } else {
      userBadgesList.removeWhere((element) => element.badge.level >= 5);
    }

    selectBadge.value = userBadgesList.first;
    selectBadgeId.value = userBadgesList.first.badge.id;

    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Obx(() {
          return Column(
            children: [
              Center(
                  child: Image(
                image: CachedNetworkImageProvider(selectBadge.value.badge.imageUrl),
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
                    children: [..._getListWidgets(userBadgesList)],
                  );
                }),
              ),
            ],
          );
        }),
        actions: [
          ElevatedButton(onPressed: () => closeSelectBadge(), child: const Text('취소')),
          ElevatedButton(onPressed: () => selectedItemAddedList(index), child: const Text('확인')),
        ],
      ),
    );
  }

  void selectItem(InventoryBadgeModel badge, badgeId) {
    selectBadge.value = badge;
    selectBadgeId.value = badgeId;
  }

  void selectedItemAddedList(int index) {
    selectedBadgeList[index] = selectBadge.value;
    userBadgesList.removeWhere((element) => element.id == selectBadgeId.value);
    selectedBadgeIdList.add(selectBadge.value.badge.id);

    // if (selectedBadgeList.length == selectedBadgeLevel.value) {
    //   userBadgesList.add(selectedBadgeList[index]!);
    // } else {}
    // if (selectedBadgeList.length > selectedBadgeLevel.value) {
    //   userBadgesList.add(selectedBadgeList.firstWhere((element) => element.id == selectBadgeId.value));
    // }

    print(selectedBadgeIdList);
    Get.back();
  }

  void syntheticBadgeConfirm() async {
    // print(selectedBadgeIdList);
    InventoryBadgeModel syntheticedBadge = await BadgeService.fetchUserSyntheticBadge({
      'composeBadges': selectedBadgeIdList,
      'issueFeeTik': syntheticBadgeFee.toInt(),
    });
    inspect(syntheticedBadge);
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
  }

  void handleOpenSyntheticBadgeConfirmPopup() {
    print(syntheticBadgeFee);
    Get.dialog(
      AlertDialog(
        title: const Text(
          '합성을 진행 하시겠습니까?',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text('토큰 소모량: $syntheticBadgeFee TIK');
            }),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('취소')),
          ElevatedButton(onPressed: () => syntheticBadgeConfirm(), child: const Text('확인')),
        ],
      ),
    );
  }

  void closeSelectBadge() {
    Get.back();
  }
}
