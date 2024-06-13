import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/create_wallet_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CreateWallet extends StatelessWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateWalletController controller = Get.put(CreateWalletController());

    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultContainer(
        isLeadingShow: false,
        backgroundColor: subBg01Color,
        child: Obx(() {
          return controller.isCreatingWallet.value
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/loading_dots.json',
                        width: 200,
                        height: 120,
                        repeat: true,
                      ),
                      const StyledText(
                        '지갑을 만들고 있습니다.',
                        fontSize: 22,
                        fontWeight: 600,
                        lineHeight: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 200),
                        child: StyledText(
                          '잠시만 기다려주세요!',
                          fontSize: 16,
                          lineHeight: 22,
                          fontWeight: 500,
                          color: deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                )
              : controller.isCreationSuccessful.value
                  ? Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 122.sp,
                                  height: 122.sp,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        top: -80.sp,
                                        left: -10.sp,
                                        child: Lottie.asset(
                                          'assets/lottie/fireworks.json',
                                          width: 140,
                                          height: 120,
                                          repeat: true,
                                        ),
                                      ),
                                      Image.asset('assets/images/wallet/staika_logo.png', width: 122.sp, height: 122.sp),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 34),
                                  child: Text(
                                    'Staika 지갑을 만들었어요.',
                                    style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                                          color: AppColorData.regular().colorTextPrimary,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 200),
                                  child: Text(
                                    '이제 Staika wallet과 함께 편안한\n디지털 자산관리를 시작해보세요.',
                                    style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                          color: AppColorData.regular().colorTextPrimary,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GazagoButton(
                            onTap: () async {
                              if (Get.isRegistered<StaikaWalletController>()) {
                                await Get.find<StaikaWalletController>().getStaikaWalletInfo();
                              }
                              Get.until((route) => Get.currentRoute == Routes.wallet || Get.currentRoute == Routes.itemDetail);
                            },
                            buttonText: '시작',
                            buttonColor: skyBlueColor,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                iconAlert,
                                const Padding(
                                  padding: EdgeInsets.only(top: 37),
                                  child: StyledText(
                                    '잠시 후 다시 시도해 주세요.',
                                    fontSize: 22,
                                    fontWeight: 600,
                                    lineHeight: 26,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 200),
                                  child: StyledText(
                                    '블록체인 네트워크의 불안정 혹은 일시적인\n오류로 지갑 생성을 완료할 수 없었습니다.\n죄송하지만 잠시 후 다시 시도해 주세요.',
                                    fontSize: 16,
                                    lineHeight: 22,
                                    fontWeight: 500,
                                    color: deepGrayColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GazagoButton(
                            onTap: () {
                              Get.find<WalletMasterController>().tabController.index = 0;
                              Get.back();
                            },
                            buttonText: '돌아가기',
                            buttonColor: skyBlueColor,
                          ),
                        ),
                      ],
                    );
        }),
      ),
    );
  }
}
