import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/wallet/asset_item_coin.dart';
import 'package:get/get.dart';

class SpendingWallet extends StatelessWidget {
  const SpendingWallet({Key? key}) : super(key: key);

  List<Widget> renderInventoryList(WalletMasterController controller) {
    return controller.spendingTokenUiList
        .map(
          (asset) => Padding(
            padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
            child: AssetItemCoin(
              asset: asset,
              onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.inventory, assetType: asset.name!.toUpperCase() == 'TAIKA' ? AssetType.token : AssetType.coin),
              // TODO. 외부지갑 기능 연동시 다시 기능 개선 / 주석 해제
              // onTapButton: asset.meta!.name.toUpperCase() == 'TAIKA' ? () => controller.toBuyTik() : null,
              // buttonText: asset.meta!.name.toUpperCase() == 'TAIKA' ? '충전' : null,
              showPrice: false,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Obx(() {
        return Column(
          children: [
            ...renderInventoryList(controller),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 33.sp, right: 33.sp, top: 28.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  StyledText(
                    'Taika 사용하기',
                    fontSize: 16,
                    fontWeight: 600,
                    lineHeight: 20,
                    letterSpacing: -0.5,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
              child: Ink(
                decoration: BoxDecoration(
                  color: subBg02Color,
                  border: Border.all(width: 2.sp, color: Colors.black),
                  borderRadius: BorderRadius.circular(12.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2.sp, 4.sp),
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () => controller.moveToTaikaPay(),
                  borderRadius: BorderRadius.circular(12.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 22.sp,
                          left: 16.sp,
                          right: 16.sp,
                          bottom: 22.sp,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              radius: 19.sp,
                              backgroundColor: Colors.black,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                child: const StyledText(
                                  '상품권 교환',
                                  fontSize: 18,
                                  lineHeight: 18,
                                  fontWeight: 500,
                                ),
                              ),
                            ),
                            iconArrowRight,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
