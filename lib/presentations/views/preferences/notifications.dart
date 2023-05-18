import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NoticePopupController controller = Get.find<NoticePopupController>();

    List<Widget> renderSubPopupList(NoticePopupController controller) {
      return controller.noticePopupList
          .map(
            (notice) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(top: 14),
              child: GestureDetector(
                onTap: () => controller.moveToWebView(notice),
                child: Image.network(
                  notice.subImageUrl!,
                ),
              ),
            ),
          )
          .toList();
    }

    return DefaultContainer(
      titleText: '알림',
      backgroundColor: subBg01Color,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Obx(() {
              return Column(
                children: [
                  ...renderSubPopupList(controller),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
