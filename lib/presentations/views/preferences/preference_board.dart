import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/preference_board_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class PreferenceBoard extends StatelessWidget {
  const PreferenceBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: controller.boardName.value,
      child: Obx(() {
        return ListView.builder(
            itemCount: controller.boardList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      width: 2.sp,
                      color: popupBgColor.withOpacity(0.5),
                    ),
                  )),
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
                    onExpansionChanged: (bool expanded) {
                      controller.toggleExpansion(controller.boardList[index], expanded);
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: StyledText(
                            'Q',
                            color: skyBlueColor,
                            fontSize: 18,
                            lineHeight: 18,
                            fontWeight: 700,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                            ),
                            child: StyledText(
                              controller.boardList[index].title!,
                              color: Colors.white,
                              fontSize: 18,
                              lineHeight: 22,
                              fontWeight: 500,
                            ),
                          ),
                        ),
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 9,
                            ),
                            child: controller.boardList[index].isChecked ? iconChevronUp : iconChevronDown,
                          );
                        })
                      ],
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
                              color: skyBlueColor.withOpacity(0.5),
                              width: 2.sp,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 6.sp,
                                top: 2.sp,
                              ),
                              child: iconAnswer,
                            ),
                            Expanded(
                                child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  skyBlueColor,
                                  const Color(0xff0EF3D8),
                                ],
                              ).createShader(
                                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                              ),
                              child: StyledText(
                                controller.boardList[index].content!,
                                color: lightGrayColor,
                                fontSize: 16,
                                lineHeight: 22,
                                fontWeight: 500,
                              ),
                            )),
                          ],
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
