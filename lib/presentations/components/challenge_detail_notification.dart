import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/models/challenge_notification_group_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

void showChallengeNotification(ChallengesDetailController controller, ChallengeNotificationGroupModel challengeNotificationGroup) {
  List<dynamic> notifiedChallengeList = HiveStore.load(key: HiveKey.notifiedChallengeList.name) ?? [];
  bool hasNotified = notifiedChallengeList.any((id) => id == controller.challengeId.value);

  if (hasNotified) return;

  notifiedChallengeList.add(controller.challengeId.value);
  HiveStore.save(key: HiveKey.notifiedChallengeList.name, value: notifiedChallengeList);

  int notificationLength = challengeNotificationGroup.challengeNotifications.length;
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: selectedIndex,
  );

  List<Widget> renderDots(int selectedIndex) {
    List<Widget> dots = List.empty(growable: true);
    for (int i = 0; i < notificationLength; i++) {
      if (i == 0) {
        dots.add(
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: selectedIndex == i ? skyBlueColor : subBg01Color,
            ),
          ),
        );
      } else {
        dots.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedIndex == i ? skyBlueColor : subBg01Color,
              ),
            ),
          ),
        );
      }
    }

    return dots;
  }

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
          color: popupBgColor,
        ),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExpandablePageView.builder(
                itemCount: notificationLength,
                pageSnapping: true,
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                allowImplicitScrolling: true,
                onPageChanged: (page) {
                  setState(() {
                    selectedIndex = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 320.sp,
                        child: Image.network(
                          width: double.infinity,
                          fit: BoxFit.fill,
                          challengeNotificationGroup.challengeNotifications[pagePosition].imageUrl,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: popupBgColor,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 12.sp,
                            left: 20.sp,
                            right: 20.sp,
                            bottom: 6.sp,
                          ),
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: Html(
                                shrinkWrap: true,
                                data: challengeNotificationGroup.challengeNotifications[pagePosition].message,
                                style: {
                                  "*": Style(
                                    lineHeight: LineHeight.percent(130),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize(18.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize(18.sp),
                                    lineHeight: LineHeight.percent(130),
                                    textAlign: TextAlign.center,
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Container(
                color: popupBgColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: 0,
                        bottom: 0,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...renderDots(selectedIndex),
                            ],
                          ),
                        ),
                      ),
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
                            fontSize: 14,
                            fontWeight: 500,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.sp, right: 6.sp, bottom: 6.sp),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (selectedIndex < notificationLength - 1) {
                                  selectedIndex++;
                                  pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                } else {
                                  Get.back();
                                }
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(10.sp),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.transparent,
                            ),
                            child: StyledText(
                              selectedIndex < notificationLength - 1 ? '다음' : '시작하기',
                              fontSize: 14,
                              fontWeight: 500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    ),
  );
}
