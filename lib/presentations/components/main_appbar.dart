import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainBg01Color,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.symmetric(vertical: 3.0.sp),
            onPressed: null,
            icon: iconHeaderLogo,
            constraints: BoxConstraints(
              minWidth: 100.sp,
            ),
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                onPressed: () => Get.toNamed(Routes.preferences),
                icon: iconHeaderAvatar,
                splashRadius: 20.sp,
                constraints: BoxConstraints(
                  minWidth: 24.sp,
                ),
              ),
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                onPressed: () => Get.toNamed(Routes.wallet),
                icon: iconHeaderWallet,
                splashRadius: 20.sp,
                constraints: BoxConstraints(
                  minWidth: 24.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
