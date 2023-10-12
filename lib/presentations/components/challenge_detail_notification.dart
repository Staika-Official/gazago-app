import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

void showChallengeNotification(ChallengesDetailController controller) {
  List<int> notifiedChallengeList = HiveStore.load(key: HiveKey.notifiedChallengeList.name) ?? [];
  bool hasNotified = notifiedChallengeList.any((id) => id == controller.challengeId.value);

  if (hasNotified) return;

  notifiedChallengeList.add(controller.challengeId.value);
  HiveStore.save(key: HiveKey.notifiedChallengeList.name, value: notifiedChallengeList);

  Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        width: 320.sp,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 320.sp,
              color: Colors.white,
            ),
            Container(
              color: popupBgColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 26.sp,
                      left: 25.sp,
                      right: 25.sp,
                      bottom: 15.sp,
                    ),
                    child: const StyledText(
                      '릴레이 기간동안 능력치를 받을 수 있는 크루버프가 새로 생겼어요',
                      fontSize: 18,
                      fontWeight: 500,
                      lineHeight: 26,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.sp, left: 6.sp, bottom: 6.sp),
                          child: TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(10.sp),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.transparent,
                            ),
                            child: StyledText(
                              '건너뛰기',
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          left: 0,
                          bottom: 0,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: skyBlueColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: skyBlueColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: skyBlueColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: skyBlueColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.sp, right: 6.sp, bottom: 6.sp),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(10.sp),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: Colors.transparent,
                              ),
                              child: const StyledText('다음'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
