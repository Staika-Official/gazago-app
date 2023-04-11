import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/wallet/go_asset_item_coin.dart';
import 'package:get/get.dart';

class GoWallet extends StatelessWidget {
  const GoWallet({Key? key}) : super(key: key);

  List<Widget> renderInventoryList(WalletMasterController controller) {
    return controller.spendingTokenUiList
        .map(
          (asset) => Padding(
            padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
            child: GoAssetItemCoin(
              asset: asset,
              onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.inventory, assetType: asset.name!.toUpperCase() == 'TAIKA' ? AssetType.token : AssetType.coin),
              onTapButton: asset.name!.toUpperCase() == 'TAIKA' ? () => controller.showProductDialog() : () => controller.showProductStikDialog(),
              buttonText: asset.name!.toUpperCase() == 'TAIKA' ? 'TIK 충전' : 'TIK 으로 교환',
              buttonIcon: asset.name!.toUpperCase() == 'TAIKA' ? iconTikCharge : iconStikExchange,
              showPrice: false,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();

    return Scaffold(
      backgroundColor: mainBg01Color,
      body: Obx(() {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 25.sp, right: 33.sp, top: 18.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    StyledText(
                      '디지털 자산',
                      fontSize: 16,
                      fontWeight: 600,
                      lineHeight: 20,
                      letterSpacing: -0.5,
                    ),
                  ],
                ),
              ),
            ),
            ...renderInventoryList(controller),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 25.sp, right: 33.sp, top: 28.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  StyledText(
                    '디지털 자산 사용',
                    fontSize: 16,
                    fontWeight: 500,
                    lineHeight: 20,
                    letterSpacing: -0.5,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.sp, left: 21.sp, right: 21.sp),
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
                  onTap: () => controller.onClickMoveToTaikaPay(),
                  borderRadius: BorderRadius.circular(12.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.sp,
                          left: 16.sp,
                          right: 16.sp,
                          bottom: 20.sp,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              radius: 30.sp,
                              foregroundImage: Image.asset('assets/images/wallet/ico_coupon.png').image,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      'TIK 사용하기',
                                      fontSize: 14,
                                      lineHeight: 14,
                                      fontWeight: 600,
                                      color: deepGrayColor,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.0.sp),
                                      child: const StyledText(
                                        'TIK으로 기프티콘 교환',
                                        fontSize: 16,
                                        lineHeight: 24,
                                        fontWeight: 500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0.sp),
                  child: StyledText(
                    '· GO 지갑은 가자고 내에서 TIK과 STIK을 관리하는 지갑입니다.',
                    fontWeight: 500,
                    fontSize: 10,
                    letterSpacing: -.1,
                    color: deepGrayColor,
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
