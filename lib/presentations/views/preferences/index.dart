import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Preferences extends StatelessWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceController controller = Get.put(PreferenceController());

    return DefaultContainer(
      titleText: '설정',
      backgroundColor: const Color(0xFF1D1D26),
      headerBackgroundColor: Color(0xFF23232D),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0.sp),
            child: Obx(() {
              return InkWell(
                onTap: () => Get.toNamed(Routes.myPage),
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
                              foregroundImage: controller.profile.value.profileImageUrl != null
                                  ? CachedNetworkImageProvider(
                                      controller.profile.value.profileImageUrl!,
                                    )
                                  : Image.asset(
                                      'assets/images/ic_launcher.png',
                                      width: 30.sp,
                                    ).image,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 14.0.sp),
                              child: StyledText(
                                controller.profile.value.nickname!,
                                fontWeight: 500,
                                fontSize: 14,
                                lineHeight: 20,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, color: Color(0xFFBDC0C7), size: 24.sp)
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          // PreferenceItem(
          //   title: '본인인증',
          //   onTap: () => Get.toNamed(Routes.verification),
          // ),
          // PreferenceItem(
          //   title: '알림',
          //   onTap: () => Get.toNamed(Routes.preferenceNotification),
          // ),
          PreferenceItem(
            title: '공지사항',
            onTap: () => Get.toNamed(Routes.preferenceBoard, arguments: {'boardType': 'T2E_NOTICE'}),
          ),
          PreferenceItem(
            title: 'FAQ',
            onTap: () => Get.toNamed(Routes.preferenceBoard, arguments: {'boardType': 'T2E_FAQ'}),
          ),
          Container(
            width: double.infinity,
            height: 6.sp,
            color: Color(0xFF23232D),
          ),
          PreferenceItem(
            title: '약관',
            onTap: () => Get.toNamed(Routes.termsList),
          ),
          PreferenceItem(
            title: '마케팅 동의',
            onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'T2E_MARKETING'}),
          ),
          Container(
            width: double.infinity,
            height: 6.sp,
            color: Color(0xFF23232D),
          ),
          PreferenceItem(
            title: '로그아웃',
            onTap: () => controller.showLogoutConfirmation(),
          ),
          Obx(() {
            return PreferenceItem(
              title: '버전정보',
              type: ItemType.descriptive,
              description: controller.appVersion.value,
            );
          }),
        ],
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

  const PreferenceItem({Key? key, required this.title, this.type = ItemType.functional, this.onTap, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 60.sp,
      color: Color(0xFF1D1D26),
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
                  ? Icon(Icons.chevron_right, color: Color(0xFFBDC0C7), size: 24.sp)
                  : Padding(
                      padding: EdgeInsets.only(right: 5.sp),
                      child: StyledText(
                        'v${description!}',
                        fontSize: 16,
                        fontWeight: 500,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
