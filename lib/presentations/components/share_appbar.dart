import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ShareAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final bool isBeta;
  final bool? isLockButton;
  const ShareAppbar({Key? key, this.titleText, this.isBeta = false, this.isLockButton = false}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.find();
    return AppBar(
      backgroundColor: subBg01Color,
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            padding: EdgeInsets.zero,
            child: IconButton(
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              iconSize: 30,
              splashRadius: 30.sp,
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Colors.white,
              ),
            ),
          ),
          if (titleText != null)
            Stack(
              clipBehavior: Clip.none,
              children: [
                StyledText(
                  titleText!,
                  // '크루 릴레이',
                  fontSize: 18,
                  lineHeight: 18,
                  fontWeight: 500,
                ),
                Positioned(
                  right: -45,
                  top: -2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: skyBlueColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.sp),
                        child: StyledText(
                          'Beta',
                          color: Colors.black,
                          fontSize: 12,
                          lineHeight: 12,
                          fontWeight: 600,
                          letterSpacing: -.1,
                        )),
                  ),
                )
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLockButton!
                  ? Padding(
                      padding: EdgeInsets.only(left: 4.sp),
                      child: IconButton(
                        onPressed: () => null,
                        icon: iconHeaderShare,
                        splashRadius: 20.sp,
                        constraints: BoxConstraints(
                          minWidth: 30.sp,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 4.sp),
                      child: IconButton(
                        onPressed: () => controller.sharedKakaoCrewChallenge(),
                        icon: iconHeaderShare,
                        splashRadius: 20.sp,
                        constraints: BoxConstraints(
                          minWidth: 30.sp,
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
