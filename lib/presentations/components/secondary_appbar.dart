import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isShowBackButton;
  final bool isShowPreferencesButton;
  const SecondaryAppbar({super.key, this.isShowBackButton = false, this.isShowPreferencesButton = true});

  List<Widget> renderWalletItems(WalletMasterController walletMasterController) {
    return walletMasterController.spendingTokenUiList.map((token) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: Row(
          children: [
            CircleAvatar(
              radius: 11.sp,
              foregroundImage: token.logoUrl != '' && token.logoUrl != null
                  ? CachedNetworkImageProvider(
                      token.logoUrl!,
                      headers: imageNetworkHeader,
                    )
                  : const sp.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 90),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: StyledText(
                    token.symbol! == 'STIK' ? formatDecimalPlaces(double.parse(token.uiAmountString!), 2, isAutoDecimal: true) : formatDecimalPlaces(double.parse(token.uiAmountString!), 0),
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: 600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());
    HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>() : Get.put(HomeMenuController());
    return AppBar(
      backgroundColor: subBg01Color,
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isShowBackButton
                ? Container(
                    width: 24,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      iconSize: 24,
                      splashRadius: 24.sp,
                      icon: iconHeaderBack,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 3.0.sp),
                    constraints: BoxConstraints(
                      minWidth: 100.sp,
                    ),
                    child: StyledText(
                      homeMenuController.selectedMenuTitle(),
                      fontWeight: 600,
                      fontSize: 22,
                      lineHeight: 30,
                    ),
                  ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                walletMasterController.isWalletGetLoading.value == true
                    ? Container(
                  width: 20.sp,
                  height: 20.sp,
                  child: const CircularProgressIndicator(color: skyBlueColor),
                ) :
                InkWell(
                  onTap: () => walletMasterController.getSpendingWalletBalances(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),

                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 4.0.sp,
                          bottom: 4.0.sp,
                          left: 8.sp,
                          right: 8.sp,
                        ),
                        child: walletMasterController.spendingTokens.value.isEmpty ?
                        Row(
                          children: [
                            Stack(children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15.0.sp),
                                child: iconHeaderStik,
                              ),
                              iconHeaderTik
                            ]),

                            Padding(
                              padding: EdgeInsets.only(left:4.0.sp),
                              child: Text(
                                '지갑 다시 불러오기',
                                style: AppTextStyleData
                                    .regular()
                                    .koBodyMediumMd
                                    .copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextPrimary,

                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:4.0.sp, right: 0.0.sp),
                              child: iconHeaderRefresh,
                            )
                          ],
                        )
                            : InkWell(
                          onTap: () => walletMasterController.moveToWallet(),
                          child: Row(
                            children: [
                              ...renderWalletItems(walletMasterController),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isShowPreferencesButton)
                  Padding(
                    padding: EdgeInsets.only(left: 4.sp),
                    child: IconButton(
                      onPressed: () => Get.toNamed(Routes.preferences),
                      icon: iconHeaderGear,
                      splashRadius: 20.sp,
                      iconSize: 30,
                      constraints: BoxConstraints(
                        minWidth: 30.sp,
                      ),
                    ),
                  )
              ],
            ),
          ],
        );
      }),
    );
  }
}
