import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/components/beta_tag.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ShareAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final bool isBeta;
  final bool? isLockButton;

  const ShareAppbar({super.key, this.titleText, this.isBeta = false, this.isLockButton = false});

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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200.sp),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: StyledText(
                      titleText!,
                      // 'crew_relay_1'.tr(),
                      fontSize: 18,
                      lineHeight: 18,
                      fontWeight: 500,
                    ),
                  ),
                ),
                if (isBeta)
                  const Positioned(
                    right: -45,
                    top: -3,
                    child: BetaTag(),
                  )
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLockButton != null && isLockButton!
                  ? Obx(() {
                      return Get.find<CrewDetailController>().isFounder.value
                          ? Padding(
                              padding: EdgeInsets.only(left: 4.sp),
                              child: IconButton(
                                onPressed: () => Get.find<CrewDetailController>().validateRecruitLock(),
                                icon: Get.find<CrewDetailController>().selectedCrew.value.crewRecruitStatus! == 'CLOSE' ? iconHeaderLock : iconHeaderUnlock,
                                splashRadius: 20.sp,
                                constraints: BoxConstraints(
                                  minWidth: 30.sp,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 30.sp,
                            );
                    })
                  : Padding(
                      padding: EdgeInsets.only(left: 4.sp),
                      child: IconButton(
                        onPressed: () =>
                            controller.shareChallenge(challengeType: Get.currentRoute.contains('company') ? ChallengeType.companyCrew : ChallengeType.crew, shareSource: ShareSource.shareAppbar),
                        icon: Platform.isAndroid ? iconHeaderShare : iconHeaderShareIOS,
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
