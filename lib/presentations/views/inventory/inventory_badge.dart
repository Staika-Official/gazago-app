import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';

class InventoryBadge extends StatelessWidget {
  const InventoryBadge({Key? key}) : super(key: key);

  List<Widget> renderMyBadgeList(InventoryController controller) {
    return controller.myBadgeList
        .map(
          (badge) => InkWell(
            onTap: () => controller.toBadgeDetail(badge.id),
            child: Image(
              image: AssetImage('assets/images/@temp_badge.png'),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 4,
      children: <Widget>[
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...renderMyBadgeList(controller),
            ],
          ),
        ),
      ],
    );
  }
}
