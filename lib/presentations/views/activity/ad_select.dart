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
                  const StyledText(
                    '선택해주세요',
                    fontSize: 24,
                    fontWeight: 700,
                    lineHeight: 32,
                    fontFamily: 'Montserrat',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.sp, left: 7.0.sp),
                    child: InkWell(
                      onTap: () => controller.showAdTip(),
                      child: iconExclamation,
                    ),
                  )
                ],
              ),
            ),
            Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0.sp),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 154.sp,
                      decoration: BoxDecoration(
                        color: controller.startAd.value != null ? skyBlueColor : popupBgColor,
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
                        onTap: () => controller.startAd.value != null ? controller.showAdAndMoveActivity() : null,
                        borderRadius: BorderRadius.circular(14.sp),
                        child: Padding(
                          padding: EdgeInsets.only(top: 22.sp, left: 10.sp, right: 10.sp),
                          child: Column(
                            children: [
                              controller.adLoadingTime.value == 0
                                  ? controller.startAd.value != null
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 22.0.sp),
                                          child: iconGo,
                                        )
                                      : Opacity(
                                          opacity: 0.4,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 22.0.sp),
                                            child: iconGo,
                                          ))
                                  : controller.startAd.value == null
                                      ? Padding(
                                          padding: EdgeInsets.only(bottom: 5.0.sp),
                                          child: Stack(
                                            children: [
                                              Text(
                                                controller.adLoadingTime.value.toString(),
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                  foreground: Paint()..color = skyBlueColor,
                                                ),
                                              ),
                                              Text(
                                                controller.adLoadingTime.value.toString(),
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                  foreground: Paint()
                                                    ..strokeWidth = 2
                                                    ..color = Colors.black
                                                    ..style = PaintingStyle.stroke,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(top: 22.0.sp),
                                          child: iconGo,
                                        ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.sp),
                                child: FittedBox(
                                  alignment: Alignment.topCenter,
                                  child: controller.adLoadingTime.value == 0 && controller.startAd.value == null
                                      ? const StyledText(
                                          '아직 광고가 부족해요...',
                                          color: Color(0xFFC0C2C8),
                                          fontSize: 20,
                                          fontWeight: 600,
                                          lineHeight: 20,
                                          fontFamily: 'Montserrat',
                                        )
                                      : StyledText(
                                          '광고 보고, ${controller.selectedCourse.value == null && controller.selectedExerciseType.value != ExerciseType.hiking ? '1' : '3'}GO 받고 시작하기',
                                          color: controller.startAd.value == null ? const Color(0xFF767883) : Colors.black,
                                          fontSize: 20,
                                          fontWeight: 600,
                                          lineHeight: 20,
                                          fontFamily: 'Montserrat',
                                          letterSpacing: -.1,
                                        ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 7.sp),
                              //   child: const StyledText(
                              //     '광고 수익의 75%를 보상으로 제공해요.',
                              //     color: Colors.black,
                              //     fontSize: 12,
                              //     fontWeight: 500,
                              //     lineHeight: 13,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
                        width: 2,
                        style: BorderStyle.solid,
                        color: skyBlueColor,
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
                onTap: () => controller.closeAdSelectPopup(),
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
