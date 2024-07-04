import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

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
                  : sp.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 90),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      token.symbol! == 'STIK' ? formatDecimalPlaces(double.parse(token.uiAmountString!), 2, isAutoDecimal: true) : formatDecimalPlaces(double.parse(token.uiAmountString!), 0),
                      style: AppTextStyleData
                          .regular()
                          .koBodyMediumSm
                          .copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,

                      )
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
    NoticePopupController controller = Get.put(NoticePopupController());
    WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());

    return AppBar(
      backgroundColor: AppColorData
          .regular()
          .colorBgPrimary,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
                    right: 6.sp,
                  ),
                  child: InkWell(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal:9.sp),
                      onPressed: () => controller.moveToNotificationsListPage(),
                      icon: iconHeaderBell,
                      splashRadius: 15.sp,
                      iconSize: 21.sp,
                      constraints: BoxConstraints(
                        minWidth: 21.sp,
                      ),
                    ),
                    Obx(() {
                      return controller.hasNewNotice.value
                          ? Positioned(
                        top: 12.sp,
                        right: 12.sp,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xffFF1414),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                          : Container();
                    })
                  ],
                ),

                IconButton(
                  padding: EdgeInsets.symmetric(horizontal:9.sp),
                  onPressed: () {
                    Get.toNamed(Routes.preferences);
                    Adjust.trackEvent(AdjustEvent('j66t7q'));
                  },
                  icon: iconHeaderGear,
                  splashRadius: 15.sp,
                  iconSize: 21,
                  constraints: BoxConstraints(
                    minWidth: 21.sp,
                  ),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}
