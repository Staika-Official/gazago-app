import 'package:flutter/material.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/synthetic_badge_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class SyntheticBadge extends StatelessWidget {
  const SyntheticBadge({super.key});

  @override
  Widget build(BuildContext context) {
    HomeMenuController homeMenuController = Get.find();
    InventoryController controller = Get.find();

    SyntheticBadgeController syntheticBadgeController =
        Get.put(SyntheticBadgeController(controller.selectedBadge));

    return Scaffold(
      appBar: homeMenuController.appbarList[1],
      body: Container(
        color: subBg01Color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Wrap(
                      runSpacing: 25.0,
                      spacing: 50.0,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        for (int i = 0;
                            i <
                                syntheticBadgeController
                                    .selectedBadgeLevel.value;
                            i++)
                          Obx(() {
                            return GestureDetector(
                              onTap: () => i != 0
                                  ? syntheticBadgeController
                                      .showSelectBadgePopup(
                                          controller.userBadgesList,
                                          controller.selectedBadge.value,
                                          i)
                                  : null,
                              child: CircleAvatar(
                                backgroundImage: const AssetImage(
                                    'assets/images/inventory/ico_circle_plus.png'),
                                foregroundImage: NetworkImage(
                                  syntheticBadgeController
                                              .selectedBadgeList[i] !=
                                          null
                                      ? syntheticBadgeController
                                              .selectedBadgeList[i]!.imageUrl ??
                                          ''
                                      : '',
                                  headers: imageNetworkHeader,
                                ),
                                radius: 54,
                              ),
                            );
                          })
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: syntheticBadgeController
                                .selectedBadgeList.length ==
                            syntheticBadgeController.selectedBadgeLevel.value
                        ? () => syntheticBadgeController
                            .handleOpenSyntheticBadgeConfirmPopup()
                        : null,
                    child: Text('synthesis'.tr()),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
