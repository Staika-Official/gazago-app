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
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

class CreateWallet extends StatelessWidget {
  const CreateWallet({super.key});

  @override
  Widget build(BuildContext context) {
    CreateWalletController controller = Get.put(CreateWalletController());

    return PopScope(
      canPop: false,
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
                      StyledText(
                        'creating_wallet'.tr(),
                        fontSize: 22,
                        fontWeight: 600,
                        lineHeight: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 200),
                        child: StyledText(
                          'please_wait'.tr(),
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
                                      Image.asset(
                                          'assets/images/wallet/staika_logo.png',
                                          width: 122.sp,
                                          height: 122.sp),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 34),
                                  child: Text(
                                    'wallet_created'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koHeadingMediumSm
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorTextPrimary,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 200),
                                  child: Text(
                                    'start_asset_management'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koBodyMediumLg
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorTextPrimary,
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
                                await Get.find<StaikaWalletController>()
                                    .getStaikaWalletInfo();
                              }
                              Get.until((route) =>
                                  Get.currentRoute == Routes.wallet ||
                                  Get.currentRoute == Routes.itemDetail);
                            },
                            buttonText: 'start'.tr(),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 37),
                                  child: StyledText(
                                    'retry_later_1'.tr(),
                                    fontSize: 22,
                                    fontWeight: 600,
                                    lineHeight: 26,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 200),
                                  child: StyledText(
                                    'wallet_creation_failed'.tr(),
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
                              Get.find<WalletMasterController>()
                                  .tabController
                                  .index = 0;
                              Get.back();
                            },
                            buttonText: 'go_back'.tr(),
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
