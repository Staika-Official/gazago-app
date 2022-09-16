import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/home_menu_controller.dart';
import 'package:step_go/platform/controllers/inventory_controller.dart';

class SyntheticBadge extends StatelessWidget {
  const SyntheticBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeMenuController homeMenuController = Get.find();
    InventoryController _controller = Get.find();
    return Obx(() {
      return Scaffold(
          appBar: homeMenuController.appbarList[1],
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(_controller.selectedBadge.value.badgeName),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                new Container(
                                  width: 100,
                                  height: 100,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: AssetImage(_controller.selectedBadge.value.badgeImageUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(_controller.selectedBadge.value.badgeName),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => null,
                      child: const Text('합성'),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
