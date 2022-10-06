import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class WalletDetail extends StatelessWidget {
  const WalletDetail({Key? key}) : super(key: key);

  // Widget renderButtons(WalletDetailController controller) {
  //   Widget child;
  //   if (controller.isInternalTransfer.value) {
  //     child = ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.sendToAsset), child: Text('내 지갑으로 보내기'));
  //   } else if (controller.isRechargeable.value) {
  //     child = ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.recharge), child: Text('충전'));
  //   } else {
  //     child = Row(
  //       children: [
  //         Expanded(child: ElevatedButton(onPressed: () => controller.toWalletAction(WalletActionType.receive), child: Text('받기'))),
  //         Expanded(
  //             child: ElevatedButton(
  //                 onPressed: () => controller.toWalletAction(WalletActionType.sendToInventory),
  //                 child: Text(
  //                   '인벤토리로\n보내기',
  //                   textAlign: TextAlign.center,
  //                 ))),
  //         Expanded(
  //             child: ElevatedButton(
  //                 onPressed: () => controller.toWalletAction(WalletActionType.sendOutside),
  //                 child: Text(
  //                   '회부 지갑으로\n보내기',
  //                   textAlign: TextAlign.center,
  //                 ))),
  //       ],
  //     );
  //   }
  //   return child;
  // }

  List<Widget> renderTransactionList(WalletMasterController controller) {
    return controller.assetDetail.value.transactions
        .map(
          (transaction) => Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(transaction.description!),
                    Text('${transaction.uiAmountString!} ${transaction.symbol!}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate(transaction.timestamp!)),
                    Text(transaction.confirmationStatus!),
                  ],
                )
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();

    return DefaultContainer(
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: controller.selectedAsset.value.meta?.logoUrl != ''
                      ? CachedNetworkImageProvider(controller.selectedAsset.value.meta!.logoUrl)
                      : Svg('assets/images/ico_token_tik.svg') as ImageProvider,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(controller.selectedAsset.value.meta!.name),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${'${controller.assetDetail.value.balance.amount} ${controller.selectedAsset.value.meta!.symbol}'} '),
            ),
            controller.selectedAsset.value.price!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('\u2248 \$100'),
                  )
                : Container(),
            // SizedBox(
            //   width: double.infinity,
            //   child: renderButtons(controller),
            // ),
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
              child: controller.assetDetail.value.transactions.isEmpty
                  ? Center(
                      child: Text('거래내역이 없습니다.'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [...renderTransactionList(controller)],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
