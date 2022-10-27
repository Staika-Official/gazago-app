import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/synthetic_badge_controller.dart';
import 'package:get/get.dart';

class SyntheticBadge extends StatelessWidget {
  const SyntheticBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeMenuController homeMenuController = Get.find();
    InventoryController controller = Get.find();

    SyntheticBadgeController _controller = Get.put(SyntheticBadgeController(controller.selectedBadge));

    return Scaffold(
      appBar: homeMenuController.appbarList[1],
      body: Container(
        color: Color(0xFF1D1D26),
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
                        for (int i = 0; i < _controller.selectedBadgeLevel.value; i++)
                          Obx(() {
                            return GestureDetector(
                              onTap: () => i != 0 ? _controller.showSelectBadgePopup(controller.userBadgesList.value, controller.selectedBadge.value, i) : null,
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/inventory/ico_circle_plus.png'),
                                foregroundImage: NetworkImage(_controller.selectedBadgeList[i] != null ? _controller.selectedBadgeList[i]!.imageUrl ?? '' : ''),
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
                    onPressed: _controller.selectedBadgeList.length == _controller.selectedBadgeLevel.value ? () => _controller.handleOpenSyntheticBadgeConfirmPopup() : null,
                    child: const Text('합성'),
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
