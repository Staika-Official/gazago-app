import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';
import 'package:step_go/platform/controllers/wallet_detail_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class WalletDetail extends StatelessWidget {
  const WalletDetail({Key? key}) : super(key: key);

  Widget renderButtons(WalletDetailController controller) {
    Widget child;
    if (controller.isInternalTransfer.value) {
      child = ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.sendToAsset), child: Text('내 지갑으로 보내기'));
    } else if (controller.isRechargeable.value) {
      child = ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.recharge), child: Text('충전'));
    } else {
      child = Row(
        children: [
          Expanded(child: ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.receive), child: Text('받기'))),
          Expanded(
              child: ElevatedButton(
                  onPressed: () => controller.toWalletAction(WalletActionType.sendToInventory),
                  child: Text(
                    '인벤토리로\n보내기',
                    textAlign: TextAlign.center,
                  ))),
          Expanded(
              child: ElevatedButton(
                  onPressed: () => controller.toWalletAction(WalletActionType.sendOutside),
                  child: Text(
                    '회부 지갑으로\n보내기',
                    textAlign: TextAlign.center,
                  ))),
        ],
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    WalletDetailController controller = Get.put(WalletDetailController());

    return DefaultContainer(
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(controller.asset.value.tokenImageUrl),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(controller.asset.value.name),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${controller.asset.value.balance.toString()} TIK'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('\u2248 \$100'),
            ),
            SizedBox(
              width: double.infinity,
              child: renderButtons(controller),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '거래내역',
                    textAlign: TextAlign.start,
                  )),
            ),
            Expanded(
              child: controller.transactionList.isEmpty
                  ? Center(
                      child: Text('거래내역이 없습니다.'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
