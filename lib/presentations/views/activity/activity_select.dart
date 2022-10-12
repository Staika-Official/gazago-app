import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';

class ActivitySelect extends StatelessWidget {
  const ActivitySelect({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.only(bottom: 42),
              child: Text(
                '어떤 활동을 하시나요?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 1,
                      top: 7,
                      child: Container(
                        width: 155,
                        height: 215,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    Obx(() {
                      return Container(
                        width: 155,
                        height: 215,
                        decoration: BoxDecoration(
                          color: Color(0xFF363841),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 4,
                            )
                          ],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundDecoration: BoxDecoration(
                          color: controller.doableChallenges.isNotEmpty ? Colors.transparent : Color.fromRGBO(0, 0, 0, 0.6),
                        ),
                        child: InkWell(
                          onTap: controller.doableChallenges.isNotEmpty ? () => controller.moveToChallangeSelection() : null,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/activity/ico_hiking.svg',
                                  width: 88,
                                  height: 88,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    '등산',
                                    style: TextStyle(
                                      color: Color(0xff4FFF4B),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 28,
                                      height: 16 / 28,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Text(
                                    '완등 후 뱃지 증정!',
                                    style: TextStyle(
                                      color: Color(0xff4FFF4B),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      height: 16 / 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 1,
                        top: 7,
                        child: Container(
                          width: 155,
                          height: 215,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      Container(
                        width: 155,
                        height: 215,
                        decoration: BoxDecoration(
                          color: Color(0xFF363841),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 4,
                            )
                          ],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          onTap: () => controller.loadExercise(ExerciseType.walking),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/activity/ico_walking.svg',
                                  width: 88,
                                  height: 88,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    '걷기',
                                    style: TextStyle(
                                      color: Color(0xff54F5FF),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 28,
                                      height: 16 / 28,
                                    ),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(113),
                child: Container(
                  width: 113,
                  height: 113,
                  decoration: BoxDecoration(
                    color: Color(0xff18191F),
                    border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.white),
                    borderRadius: BorderRadius.circular(113),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/activity/ico_close_select.svg',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
