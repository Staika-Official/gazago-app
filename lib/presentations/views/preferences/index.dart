import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          Obx(() {
            return InkWell(
              onTap: () => Get.toNamed(Routes.myPage),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                          controller.profile.value.profileImageUrl,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: StyledText('아이디뭐냐구'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          PreferenceItem(
            title: '본인인증',
            onTap: () => Get.toNamed(Routes.verification),
          ),
          PreferenceItem(
            title: '알림',
            onTap: () => Get.toNamed(Routes.preferenceNotification),
          ),
          PreferenceItem(
            title: '공지사항',
            onTap: () => Get.toNamed(Routes.preferenceBoard, arguments: {'boardType': 'NOTICE'}),
          ),
          PreferenceItem(
            title: 'FAQ',
            onTap: () => Get.toNamed(Routes.preferenceBoard, arguments: {'boardType': 'FAQ'}),
          ),
          PreferenceItem(
            title: '이용약관',
            onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'TERMS'}),
          ),
          PreferenceItem(
            title: '개인정보 처리방침',
            onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'PRIVACY'}),
          ),
          PreferenceItem(
            title: '마케팅 동의',
            onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'MARKETING'}),
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
    return Material(
      child: InkWell(
        onTap: type == ItemType.functional ? onTap : null,
        child: Container(
          height: 53,
          color: Color(0xFF1D1D26),
          padding: const EdgeInsets.only(left: 25, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                title,
                fontSize: 18,
              ),
              type == ItemType.functional
                  ? Icon(
                      Icons.chevron_right,
                      color: Color(0xFFBDC0C7),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: StyledText(
                        description!,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
