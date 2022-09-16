import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class Preferences extends StatelessWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceController controller = Get.put(PreferenceController());

    return DefaultContainer(
      child: Column(
        children: [
          Obx(() {
            return InkWell(
              onTap: () => Get.toNamed(Routes.myPage),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                        controller.profile.value.profileImageUrl,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(controller.profile.value.nickname),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('계정정보'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
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
          height: 55,
          padding: const EdgeInsets.only(left: 20, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff3a3a3a),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 14 / 16,
                ),
              ),
              type == ItemType.functional
                  ? Icon(Icons.chevron_right)
                  : Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        description!,
                        style: const TextStyle(
                          color: Color(0xff878787),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 10 / 12,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
