import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/preference_board_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class NoticeDetail extends StatelessWidget {
  const NoticeDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());
    return DefaultContainer(
      titleText: controller.noticeDetail.value.title,
      backgroundColor: subBg01Color,
      headerBackgroundColor: subBg01Color,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, bottom: 20.sp),
          child: Obx(() {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: StyledText(
                    formatDateUntilDay(
                      controller.noticeDetail.value.createdDate,
                    ),
                    color: deepGrayColor,
                    fontSize: 12,
                    lineHeight: 14,
                    fontWeight: 600,
                    fontFamily: 'Monserrat',
                    letterSpacing: .2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.sp),
                  child: StyledText(
                    controller.noticeDetail.value.content.toString(),
                    fontSize: 16,
                    lineHeight: 24,
                    fontWeight: 500,
                    fontFamily: 'Monserrat',
                    letterSpacing: .2,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
