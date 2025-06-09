import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class Preferences extends StatelessWidget {
  const Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    PreferenceController controller = Get.put(PreferenceController());
    DebuggingController debuggingController = Get.put(DebuggingController());

    return DefaultContainer(
      titleText: 'settings'.tr(),
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0.sp),
                child: Obx(() {
                  return InkWell(
                    onTap: () => Get.toNamed(Routes.myPage, arguments: {
                      'provider': controller.profile.value.provider
                    }),
                    child: Container(
                      color: const Color(0xFF23232D),
                      child: Padding(
                        padding: EdgeInsets.all(20.0.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30.sp,
                                  foregroundImage: controller.profile.value
                                                  .profileImageUrl !=
                                              null &&
                                          controller.profile.value
                                                  .profileImageUrl !=
                                              ''
                                      ? CachedNetworkImageProvider(
                                          controller
                                              .profile.value.profileImageUrl!,
                                          headers: imageNetworkHeader,
                                        )
                                      : Image.asset(
                                          'assets/images/ic_launcher.png',
                                          width: 30.sp,
                                        ).image,
                                ),
                                if (controller.profile.value.nickname != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: 14.0.sp),
                                    child: StyledText(
                                      controller.profile.value.provider ==
                                              'APPLE'
                                          ? controller.profile.value.nickname!
                                              .split('@')[0]
                                          : controller.profile.value.nickname!,
                                      fontWeight: 500,
                                      fontSize: 14,
                                      lineHeight: 20,
                                    ),
                                  ),
                              ],
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFFBDC0C7),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              controller.profile.value.authorities!
                      .contains('ROLE_CERTIFIED_USER')
                  ? SizedBox(
                      height: 60.sp,
                      child: Padding(
                          padding: EdgeInsets.only(left: 25.sp, right: 20.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyledText(
                                'identity_verification'.tr(),
                                fontSize: 18,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.sp),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color: skyBlueColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0.sp, horizontal: 10.sp),
                                    child: StyledText(
                                      'authentication_complete_1'.tr(),
                                      color: skyBlueColor,
                                      fontWeight: 500,
                                      fontSize: 14,
                                      lineHeight: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  : PreferenceItem(
                      title: 'identity_verification'.tr(),
                      onTap: () => Get.toNamed(Routes.verificationTerms),
                    ),
              Padding(
                padding: EdgeInsets.only(left: 25.sp, right: 20.sp),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText(
                        'lucky_sound_effect'.tr(),
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: Colors.white,
                      ),
                      Switch.adaptive(
                        activeColor: skyBlueColor,
                        activeTrackColor: skyBlueColor,
                        inactiveTrackColor:
                            const Color.fromRGBO(120, 120, 128, 0.16),
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        value: controller.isAbleLuckSound.value,
                        onChanged: (val) =>
                            controller.toggleLuckSoundAlarm(val),
                      )
                    ],
                  ),
                ),
              ),
              PreferenceItem(
                title: 'notification'.tr(),
                onTap: () {
                  Get.find<NoticePopupController>()
                      .moveToNotificationsListPage();
                },
              ),
              PreferenceItem(
                title: 'notice'.tr(),
                // onTap: () => Get.toNamed(Routes.noticeList, arguments: {'boardType': 'NOTICE'}),
                onTap: () {
                  Adjust.trackEvent(AdjustEvent('pk4dwp'));
                  Get.toNamed(Routes.webView, arguments: {
                    'linkUrl':
                        'https://eztechfin.notion.site/c5103042de5d4e3a9a61c1101508ffed'
                  });
                },
              ),
              PreferenceItem(
                title: 'FAQ',
                // onTap: () => Get.toNamed(Routes.preferenceBoard, arguments: {'boardType': 'FAQ'}),
                onTap: () {
                  Adjust.trackEvent(AdjustEvent('bkeekw'));
                  Get.toNamed(Routes.webView, arguments: {
                    'linkUrl':
                        'https://eztechfin.notion.site/FAQ-2f6b0ec4d6134fd398cd7a832bfa6cd3'
                  });
                },
              ),
              PreferenceItem(
                title: 'How to GO',
                onTap: () {
                  Adjust.trackEvent(AdjustEvent('tbldgc'));
                  Get.toNamed(Routes.webView,
                      arguments: {'linkUrl': F.howToGoUrl});
                },
              ),
              Container(
                width: double.infinity,
                height: 6.sp,
                color: const Color(0xFF23232D),
              ),
              PreferenceItem(
                title: 'terms_and_conditions'.tr(),
                onTap: () => Get.toNamed(Routes.termsList),
              ),
              PreferenceItem(
                title: 'marketing_agreement'.tr(),
                onTap: () => Get.toNamed(Routes.term,
                    arguments: {'termType': 'MARKETING'}),
              ),
              Container(
                width: double.infinity,
                height: 6.sp,
                color: const Color(0xFF23232D),
              ),
              PreferenceItem(
                title: 'logout'.tr(),
                onTap: () => controller.showLogoutConfirmation(),
              ),
              Obx(() {
                return GestureDetector(
                  onDoubleTap: () =>
                      debuggingController.onDebuggingModeTouchCount(),
                  child: PreferenceItem(
                    title: 'version_info'.tr(),
                    type: ItemType.descriptive,
                    description: controller.appVersion.value,
                  ),
                );
              }),
              Container(
                width: double.infinity,
                height: 6.sp,
                color: const Color(0xFF23232D),
              ),
              (F.isDev || debuggingController.isShowDebuggingMenu.value)
                  ? PreferenceItem(
                      title: 'lab'.tr(),
                      onTap: () => Get.toNamed(Routes.laboratory),
                    )
                  : Container(),
              Obx(() {
                if (debuggingController.isShowDebuggingMenu.value) {
                  return Column(
                    children: [
                      PreferenceItem(
                        title: 'Request Info',
                        onTap: () => Get.toNamed(Routes.requestInfo),
                      ),
                      PreferenceItem(
                        title: 'Response Error Logs',
                        onTap: () => Get.toNamed(Routes.responseErrorLogs),
                      ),
                      PreferenceItem(
                        title: 'Activity Logs',
                        onTap: () => Get.toNamed(Routes.activityLogs),
                      ),
                      PreferenceItem(
                        title: 'User Exercise Data Logs',
                        onTap: () => Get.toNamed(Routes.userExerciseDataLogs),
                      ),
                      PreferenceItem(
                        title: 'Position Low Data Logs',
                        onTap: () => Get.toNamed(Routes.positionRawDataLogs),
                      )
                    ],
                  );
                }
                return Container();
              })
            ],
          );
        }),
      ),
    );
  }
}

enum ItemType { functional, descriptive }

class PreferenceItem extends StatelessWidget {
  final String title;
  final ItemType type;
  final VoidCallback? onTap;
  final String? description;

  const PreferenceItem(
      {super.key,
      required this.title,
      this.type = ItemType.functional,
      this.onTap,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 60.sp,
      color: subBg01Color,
      child: InkWell(
        onTap: type == ItemType.functional ? onTap : null,
        child: Padding(
          padding: EdgeInsets.only(left: 25.sp, right: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                title,
                fontSize: 18,
              ),
              type == ItemType.functional
                  ? Icon(Icons.chevron_right,
                      color: const Color(0xFFBDC0C7), size: 24.sp)
                  : Padding(
                      padding: EdgeInsets.only(right: 5.sp),
                      child: StyledText(
                        'v${description!}',
                        fontSize: 16,
                        fontWeight: 500,
                        color: deepGrayColor,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
