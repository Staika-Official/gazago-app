import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as SP;
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
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
            padding: EdgeInsets.only(left: 3, right: 3, top: 20, bottom: 20),
            decoration: controller.assetDetail.value.transactions.last == transaction
                ? BoxDecoration()
                : BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(
                        color: Color(0xff363841),
                      ),
                    ),
                  ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: 15, top: 4, left: 4),
                  decoration: BoxDecoration(
                    color: Color(0xff0ee6f3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledText(
                            transaction.description!,
                            fontSize: 20,
                            lineHeight: 20,
                            letterSpacing: -0.5,
                            fontWeight: 600,
                          ),
                          StyledText(
                            '${formatDecimalPlaces(double.parse(transaction.uiAmountString!), transaction.decimals!)} ${transaction.symbol!}',
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: -0.5,
                            fontWeight: 700,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledText(
                              formatDate(transaction.timestamp!),
                              fontSize: 14,
                              lineHeight: 10,
                              fontWeight: 500,
                              color: Color(0xff7C7F82),
                            ),
                            StyledText(
                              transaction.confirmationStatus! == 'finalized' ? '완료' : transaction.confirmationStatus!,
                              fontSize: 12,
                              lineHeight: 10,
                              fontWeight: 600,
                              color: Color(0xff7C7F82),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();

    return Obx(() {
      return DefaultContainer(
        backgroundColor: Color(0xff1D1D26),
        titleText: controller.selectedAsset.value.meta!.name,
        child: Column(
          children: [
            // controller.selectedAsset.value.price!.isNotEmpty
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 8.0),
            //         child: Text('\u2248 \$100'),
            //       )
            //     : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: CircleAvatar(
                foregroundImage: controller.selectedAsset.value.meta?.logoUrl != ''
                    ? CachedNetworkImageProvider(controller.selectedAsset.value.meta!.logoUrl)
                    : SP.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText(
                    formatDecimalPlaces(double.parse(controller.assetDetail.value.balance.uiAmountString!), controller.assetDetail.value.balance.decimals!),
                    fontSize: 28,
                    lineHeight: 28,
                    fontWeight: 600,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: StyledText(
                      controller.selectedAsset.value.meta!.symbol,
                      fontSize: 28,
                      lineHeight: 28,
                      fontWeight: 500,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: renderButtons(controller),
            // ),
            Container(
              color: Color(0xff2A2B33),
              height: 6,
              width: double.infinity,
              margin: EdgeInsets.only(top: 50),
            ),
            Expanded(
              child: controller.assetDetail.value.transactions.isEmpty
                  ? LayoutBuilder(builder: (context, constraints) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: constraints.maxHeight / 3 * 1),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset('assets/images/wallet/ico_empty.svg'),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: StyledText(
                                  '거래내역이 없습니다.',
                                  color: Color(0xff7b7b7b),
                                  fontSize: 16,
                                  lineHeight: 10,
                                  fontWeight: 500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  : SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [...renderTransactionList(controller)],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
