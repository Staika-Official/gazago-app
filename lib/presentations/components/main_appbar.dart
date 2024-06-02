import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    NoticePopupController controller = Get.put(NoticePopupController());
    WalletMasterController walletMasterController =  Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());

    return AppBar(
      backgroundColor: mainBg01Color,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.0.sp),
            constraints: BoxConstraints(
              minWidth: 100.sp,
            ),
            child: iconHeaderLogo,
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () => controller.moveToNotificationsListPage(),
                    icon: iconHeaderBell,
                    splashRadius: 20.sp,
                    iconSize: 30,
                    constraints: BoxConstraints(
                      minWidth: 30.sp,
                    ),
                  ),
                  Obx(() {
                    return controller.hasNewNotice.value
                        ? Positioned(
                            top: 10,
                            right: 10,
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
                onPressed: () => walletMasterController.moveToWallet(),
                icon: iconHeaderWallet,
                splashRadius: 20.sp,
                iconSize: 30,
                constraints: BoxConstraints(
                  minWidth: 30.sp,
                ),
              ),
              IconButton(
                onPressed: (){
                  Get.toNamed(Routes.preferences);
                  Adjust.trackEvent(AdjustEvent('j66t7q'));
                },
                icon: iconHeaderGear,
                splashRadius: 20.sp,
                iconSize: 30,
                constraints: BoxConstraints(
                  minWidth: 30.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
