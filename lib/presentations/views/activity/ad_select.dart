import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class AdSelect extends StatelessWidget {
  const AdSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.sp, bottom: 18.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StyledText(
                    '선택해주세요',
                    fontSize: 24,
                    fontWeight: 700,
                    lineHeight: 32,
                    fontFamily: 'Montserrat',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.0.sp, left: 7.0.sp),
                    child: InkWell(
                      onTap: () => controller.showAdTip(),
                      child: iconExclamation,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0.sp),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 154.sp,
                    decoration: BoxDecoration(
                      color: skyBlueColor,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.black,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.85),
                          offset: const Offset(0, 2),
                          blurRadius: 0,
                          spreadRadius: 2.sp,
                        )
                      ],
                      borderRadius: BorderRadius.circular(14.sp),
                    ),
                    child: InkWell(
                      onTap: () => controller.showAdAndMoveActivity(),
                      borderRadius: BorderRadius.circular(14.sp),
                      child: Padding(
                        padding: EdgeInsets.only(top: 32.sp, left: 10.sp, right: 10.sp),
                        child: Column(
                          children: [
                            iconGo,
                            Padding(
                              padding: EdgeInsets.only(top: 12.sp),
                              child: FittedBox(
                                alignment: Alignment.topCenter,
                                child: StyledText(
                                  '${controller.selectedExerciseType.value == ExerciseType.walking ? '3' : '5'}GO 획득하고 시작하기',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: 600,
                                  lineHeight: 20,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 7.sp),
                              child: const StyledText(
                                '광고 수익의 75%를 보상으로 제공해요.',
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: 500,
                                lineHeight: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 36.0.sp, right: 36.0.sp, top: 14.0.sp),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 154.sp,
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.black,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.85),
                          offset: const Offset(0, 2),
                          blurRadius: 0,
                          spreadRadius: 2.sp,
                        )
                      ],
                      borderRadius: BorderRadius.circular(14.sp),
                    ),
                    child: InkWell(
                      onTap: () => controller.handleMoveExerciseActive(controller.selectedExerciseType.value),
                      borderRadius: BorderRadius.circular(14.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          StyledText(
                            '시작하기',
                            fontSize: 24,
                            fontWeight: 600,
                            lineHeight: 22,
                            fontFamily: 'Montserrat',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80.sp),
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(113.sp),
                child: Container(
                  width: 125.sp,
                  height: 57.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xff18191F),
                    border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.white),
                    borderRadius: BorderRadius.circular(113.sp),
                  ),
                  child: const Center(
                      child: StyledText(
                    '취소',
                    fontSize: 18,
                    fontWeight: 600,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
