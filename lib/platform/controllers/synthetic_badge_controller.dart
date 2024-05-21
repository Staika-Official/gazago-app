import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/inventory_mixin.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:get/get.dart';

class SyntheticBadgeController extends GetxController with InventoryMixin {
  Rx<InventoryBadgeListModel> selectedBadgePrev;
  SyntheticBadgeController(this.selectedBadgePrev);

  late RxList<InventoryBadgeListModel?> selectedBadgeList = RxList<InventoryBadgeListModel?>.filled(selectedBadgeLevel.value, null);
  RxList selectedBadgeIdList = RxList.empty();
  RxList<InventoryBadgeModel> myBadgeList = RxList.empty();
  // RxList<InventoryBadgeModel> selectedBadgeList = RxList.empty();
  RxInt get selectedBadgeLevel {
    return RxInt(selectedBadgePrev.value.level == 1 ? 5 : 2);
  }

  RxString selectedBadgeType = RxString('');
  RxList<String> get selectedBadgeImages {
    RxList<String> images = RxList.empty();
    for (int i = 0; i < selectedBadgeLevel.value; i++) {
      if (selectedBadgeList.length > i) {
        images.add(selectedBadgeList[i]!.imageUrl!);
      } else {
        images.add('');
      }
    }
    return images;
  }

  RxString get badgeType {
    switch (selectedBadgePrev.value.issueType) {
      case 'HIKING':
        return RxString('등산');
      case 'MISSION':
        return RxString('미션');
      case 'CHALLENGE':
        return RxString('도전');
      case 'COMPOSE':
        return RxString('합성');
    }
    return RxString('');
  }

  Rx<InventoryBadgeListModel> selectBadge = Rx(
    InventoryBadgeListModel(
      id: -1,
      userId: -1,
      badgeId: -1,
      level: -1,
      state: '',
      imageUrl: '',
      rewardRate: 0.0,
      luckRate: 0.0,
      name: '',
      issueType: '',
      issueEndedTime: '',
    ),
  );
  final RxInt selectBadgeId = RxInt(0);
  final RxInt selectBadgeIndex = RxInt(0);
  RxInt feeTik = RxInt(0);

  RxInt get syntheticBadgeFee {
    return RxInt(selectedBadgeList.fold(0, (prevValue, element) => prevValue + element!.level));
  }

  @override
  void onInit() {
    getUserBadgesList();

    super.onInit();
  }

  @override
  void onReady() {
    selectedBadgeType.value = selectedBadgePrev.value.issueType;
    selectedBadgeList[0] = (selectedBadgePrev.value);
    selectedBadgeIdList.add(selectedBadgePrev.value.badgeId);

    super.onReady();
  }

  List<Widget> _getListWidgets(List<InventoryBadgeListModel> list) {
    return list
        .asMap()
        .entries
        .map(
          (badge) => InkWell(
            onTap: () => selectItem(badge.value, badge.value.badgeId),
            child: Stack(
              children: [
                Text(badge.value.badgeId.toString()),
                if (selectBadge.value.badgeId == badge.value.badgeId)
                  const Positioned(
                    left: 0,
                    top: 0,
                    child: Icon(Icons.check, size: 20),
                  ),
              ],
            ),
          ),
        )
        .toList();
  }

  void showSelectBadgePopup(List<InventoryBadgeListModel> badgeItems, selectedBadgeItem, index) {
    // selectedBadgeList[index] =
    userBadgesList.removeWhere((element) => element.badgeId == selectedBadgePrev.value.badgeId);
    if (selectedBadgePrev.value.level >= 5) {
      userBadgesList.removeWhere((element) => element.level < 5);
    } else {
      userBadgesList.removeWhere((element) => element.level >= 5);
    }

    selectBadge.value = userBadgesList.first;
    selectBadgeId.value = userBadgesList.first.badgeId;

    Get.dialog(
      AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('뱃지 선택'),
          ],
        ),
        content: Obx(() {
          return Column(
            children: [
              Center(
                child: selectBadge.value.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: selectBadge.value.imageUrl!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                        httpHeaders: imageNetworkHeader,
                      )
                    : Image.asset(
                        "assets/images/@temp_badge.png",
                        fit: BoxFit.fill,
                      ),
              ),
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

  void selectItem(InventoryBadgeListModel badge, badgeId) {
    selectBadge.value = badge;
    selectBadgeId.value = badgeId;
  }

  void selectedItemAddedList(int index) {
    if (selectedBadgeList[index] != null) {
      userBadgesList.add(selectedBadgeList[index]!);
      selectedBadgeList[index] = null;
    }
    selectedBadgeList[index] = selectBadge.value;
    userBadgesList.removeWhere((element) => element.badgeId == selectBadgeId.value);
    selectedBadgeIdList.add(selectBadge.value.badgeId);

    Get.back();
  }

  void syntheticBadgeConfirm() async {
    // print(selectedBadgeIdList);
    await BadgeService.fetchUserSyntheticBadge(
      {
        'composeBadges': selectedBadgeIdList,
        'issueFeeTik': syntheticBadgeFee.toInt(),
      },
      successCallback: (InventoryBadgeModel synthesizedBadge) {
        inspect(synthesizedBadge);
        Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
      },
    );
  }

  void handleOpenSyntheticBadgeConfirmPopup() {
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
