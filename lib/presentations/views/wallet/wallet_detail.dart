import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
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
    return controller.transactionsList
        .map(
          (transaction) => Container(
            padding: EdgeInsets.only(left: 3.sp, right: 3.sp, top: 20.sp, bottom: 20.sp),
            decoration: controller.assetDetail.value.transactions.last == transaction
                ? const BoxDecoration()
                : BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(
                        color: popupBgColor,
                      ),
                    ),
                  ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 8),
                  child: transaction.type == 'IN' ? iconIn : iconOut,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledText(
                            transaction.title != null
                                ? transaction.type == 'FEE'
                                    ? '${transaction.title!} 수수료'
                                    : transaction.title!
                                : '',
                            fontSize: 22,
                            lineHeight: 22,
                            fontWeight: 500,
                          ),
                          StyledText(
                            '${transaction.type == 'IN' ? '+' : '-'} ${formatDecimalPlaces(double.parse(transaction.uiAmountString!), transaction.symbol == 'STIK' ? 4 : transaction.decimals!, isAutoDecimal: true,roundType: RoundType.floor)} ${transaction.symbol! == 'PTIK' ? 'TIK' : transaction.symbol!}',
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: -0.5,
                            fontWeight: 700,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledText(
                              formatDate(transaction.createdDate!),
                              fontSize: 14,
                              lineHeight: 10,
                              fontWeight: 500,
                              color: deepGrayColor,
                            ),
                            StyledText(
                              '완료',
                              fontSize: 12,
                              lineHeight: 10,
                              fontWeight: 600,
                              color: deepGrayColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: StyledText(
                          transaction.content ?? '',
                          fontSize: 14,
                          lineHeight: 10,
                          color: lightGrayColor,
                        ),
                      ),
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
        backgroundColor: subBg01Color,
        titleText: controller.selectedAsset.value.name!,
        child: Column(
          children: [
            // controller.selectedAsset.value.price!.isNotEmpty
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 8.0),
            //         child: Text('\u2248 \$100'),
            //       )
            //     : Container(),
            Padding(
              padding: EdgeInsets.only(top: 40.sp),
              child: CircleAvatar(
                foregroundImage: controller.selectedAsset.value.logoUrl != '' && controller.selectedAsset.value.logoUrl != null
                    ? CachedNetworkImageProvider(
                        controller.selectedAsset.value.logoUrl!,
                        headers: imageNetworkHeader,
                      )
                    : const sp.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.sp, left: 25.sp, right: 25.sp),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText(
                      formatDecimalPlaces(double.parse(controller.assetDetail.value.balance.uiAmountString!),
                          controller.assetDetail.value.balance.symbol == 'STIK' ? 4 : controller.assetDetail.value.balance.decimals!,
                          isAutoDecimal: true,roundType: RoundType.floor),
                      fontSize: 28,
                      lineHeight: 28,
                      fontWeight: 600,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: StyledText(
                        controller.selectedAsset.value.symbol! == 'TOTAL_TIK' ? 'TIK' : controller.selectedAsset.value.symbol!,
                        fontSize: 28,
                        lineHeight: 28,
                        fontWeight: 500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: renderButtons(controller),
            // ),
            Container(
              color: subBg02Color,
              height: 6,
              width: double.infinity,
              margin: EdgeInsets.only(top: 50.sp),
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
                              iconEmpty,
                              Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: const StyledText(
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
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          controller: controller.transactionScrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sp),
                            child: Column(
                              children: [
                                ...renderTransactionList(controller),
                                if (controller.dataGetLoading.value)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                                    child: const Center(child: CircularProgressIndicator()),
                                  )
                              ],
                            ),
                          ),
                        ),
                        if (controller.transactionScrollPosition.value > 100)
                          Positioned(
                            bottom: 60,
                            right: 30,
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(color: skyBlueColor, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black), boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 2),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ]),
                                child: InkWell(
                                  onTap: () => controller.transactionScrollController.animateTo(
                                    0,
                                    duration: const Duration(
                                      milliseconds: 100,
                                    ),
                                    curve: Curves.easeIn,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: iconUp,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
