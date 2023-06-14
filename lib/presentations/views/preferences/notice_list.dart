import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/preference_board_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class NoticeList extends StatelessWidget {
  const NoticeList({Key? key}) : super(key: key);

  List<dynamic> renderNoticeList(PreferenceBoardController controller) {
    return controller.boardList
        .map(
          (item) => InkWell(
            onTap: () => controller.moveNoticeDetail(item.id),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0.sp),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20.0.sp),
                          child: Text(
                            item.title!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: StyledText(
                            formatDateUntilDay(item.lastModifiedDate),
                            color: deepGrayColor,
                            fontSize: 12,
                            lineHeight: 14,
                            fontWeight: 600,
                            fontFamily: 'Montserrat',
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 10.sp,
                      child: Icon(Icons.chevron_right, color: const Color(0xFFBDC0C7), size: 24.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());
    return DefaultContainer(
      titleText: '공지사항',
      backgroundColor: subBg01Color,
      headerBackgroundColor: subBg01Color,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, bottom: 20.sp),
          child: Obx(() {
            return Column(
              children: [...renderNoticeList(controller)],
            );
          }),
        ),
      ),
    );
  }
}
