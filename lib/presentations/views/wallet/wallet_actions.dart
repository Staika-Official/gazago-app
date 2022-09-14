import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/wallet_actions_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class WalletActions extends StatelessWidget {
  const WalletActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletActionsController controller = Get.put(WalletActionsController());

    return Obx(() {
      return DefaultContainer(
        titleText: controller.actionType.value.name,
        child: Column(
          children: [
            Text('From'),
            Row(
              children: [
                TextField(),
                Text('STIK'),
              ],
            ),
            Text('To'),
            Row(
              children: [
                TextField(),
                Text('TIK'),
              ],
            ),
          ],
        ),
      );
    });
  }
}
