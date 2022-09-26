import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:get/get.dart';

class InventoryBadge extends StatelessWidget {
  const InventoryBadge({Key? key}) : super(key: key);

  List<Widget> renderUserBadgesList(InventoryController controller) {
    return controller.userBadgesList
        .map(
          (item) => InkWell(
            onTap: () => controller.toBadgeDetail(item.badge.id),
            child: Image(
              image: NetworkImage(item.badge.imageUrl),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
        )
        // .map(
        //   (badge) => Text(
        //     badge.id.toString(),
        //   ),
        // )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());

    return Obx(() {
      return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: <Widget>[
          ...renderUserBadgesList(controller),
        ],
      );
    });
  }
}
