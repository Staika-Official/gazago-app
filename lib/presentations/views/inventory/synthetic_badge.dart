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
                      //between line
                      spacing: 50.0,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,

                      children: [
                        // if (_controller.selectedBadgeList.length > 0)
                        for (int i = 0; i < _controller.selectedBadgeLevel.value; i++)
                          Obx(() {
                            return GestureDetector(
                              onTap: () => i != 0 ? _controller.showSelectBadgePopup(controller.userBadgesList.value, controller.selectedBadge.value, i) : null,
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                                foregroundImage: NetworkImage(_controller.selectedBadgeList[i] != null ? _controller.selectedBadgeList[i]!.badge.imageUrl ?? '' : ''),
                                radius: 30,
                              ),
                            );
                          })
                        // GestureDetector(
                        //   onTap: () => _controller.showSelectBadgePopup(controller.myBadgeList.value),
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                        //     // foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                        //     radius: 30,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () => _controller.showSelectBadgePopup(controller.myBadgeList.value),
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                        //     // foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                        //     radius: 30,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () => _controller.showSelectBadgePopup(controller.myBadgeList.value),
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                        //     // foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                        //     radius: 30,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () => _controller.showSelectBadgePopup(controller.myBadgeList.value),
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                        //     // foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                        //     radius: 30,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () => _controller.showSelectBadgePopup(controller.myBadgeList.value),
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/@temp_img_empty.png'),
                        //     // foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                        //     radius: 30,
                        //   ),
                        // ),
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
