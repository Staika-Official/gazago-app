import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/preference_board_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PreferenceBoard extends StatelessWidget {
  const PreferenceBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());

    return DefaultContainer(
      titleText: controller.boardName.value,
      child: Obx(() {
        return ListView.builder(
            itemCount: controller.boardList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.only(
                      left: 20.sp,
                      // top: 14,
                      right: 15.sp,
                      // bottom: 14,
                    ),
                    iconColor: const Color(0xff292929),
                    collapsedIconColor: const Color(0xff292929),
                    textColor: const Color(0xff292929),
                    collapsedTextColor: const Color(0xff292929),
                    title: StyledText(
                      controller.boardList[index].title!,
                      color: Colors.white,
                      fontSize: 18,
                      lineHeight: 22,
                      fontWeight: 500,
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5.0.sp),
                      child: StyledText(
                        DateFormat('yyyy.MM.dd').format(DateTime.parse(controller.boardList[index].lastModifiedDate!)),
                        color: Colors.white,
                        fontSize: 12,
                        lineHeight: 14,
                        fontWeight: 600,
                        fontFamily: 'Monserrat',
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: 20.sp,
                          top: 10.sp,
                          right: 20.sp,
                          bottom: 40.sp,
                        ),
                        padding: EdgeInsets.only(top: 10.sp),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xff363841),
                              width: 2.sp,
                            ),
                          ),
                        ),
                        child: StyledText(
                          controller.boardList[index].content!,
                          color: Color(0xffbfbfbf),
                          fontSize: 16,
                          lineHeight: 22,
                          fontWeight: 500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
