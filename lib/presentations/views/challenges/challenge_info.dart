import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengeInfo extends StatelessWidget {
  const ChallengeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: subBg01Color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 20.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  StyledText(
                    '챌린지 스토리',
                    fontWeight: 500,
                    fontSize: 18,
                    lineHeight: 20,
                    letterSpacing: -.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0.sp),
                    child: StyledText(
                      '5월 첫째주, 새롭게 출시된  Epic 등급의 챌린저 트레킹슈즈를 신고 최대한 많이 걸어보세요. 매일의 순위는 챌린지 리더보드에서 확인하실 수 있습니다. 챌린지 기간 종료 후 누적 거리가 50km 미만이라면 보상이 지급되지 않습니다.',
                      fontWeight: 500,
                      fontSize: 14,
                      lineHeight: 22,
                      letterSpacing: -.1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 38.0.sp, bottom: 6.sp),
                    child: StyledText(
                      '최소 거리 조건',
                      fontWeight: 500,
                      fontSize: 18,
                      lineHeight: 20,
                      letterSpacing: -.1,
                    ),
                  ),
                  StyledText(
                    '40km',
                    color: deepGrayColor,
                    fontSize: 14,
                    fontWeight: 500,
                    lineHeight: 14,
                    letterSpacing: -.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StyledText(
                          '챌린지 보상',
                          fontWeight: 500,
                          fontSize: 18,
                          lineHeight: 20,
                          letterSpacing: -.1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.0.sp),
                          child: StyledText(
                            '분배할 전체 리워드',
                            color: deepGrayColor,
                            fontSize: 14,
                            fontWeight: 500,
                            lineHeight: 14,
                            letterSpacing: -.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3038),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF2E3038),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.sp),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          iconTodayTik,
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyledText(
                                  formatDecimalPlaces(double.parse('5000000000'), 0),
                                  color: Colors.white,
                                  fontWeight: 600,
                                  fontSize: 26,
                                  lineHeight: 28,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0.sp),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StyledText(
                          '챌린지 참가 조건',
                          fontWeight: 500,
                          fontSize: 18,
                          lineHeight: 20,
                          letterSpacing: -.1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.0.sp),
                          child: StyledText(
                            '아이템 장착',
                            color: deepGrayColor,
                            fontSize: 14,
                            fontWeight: 500,
                            lineHeight: 14,
                            letterSpacing: -.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.sp),
                    child: InkWell(
                      onTap: () => null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3038),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFF2E3038),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.sp),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 10.sp),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: subBg01Color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp),
                                      ),
                                    ),
                                    width: 107.sp,
                                    height: 87.sp,
                                    child: Image.asset('assets/images/challenges/@temp_shoes.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 17.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        StyledText(
                                          '마감임박',
                                          color: skyBlueColor,
                                          fontWeight: 600,
                                          fontSize: 10,
                                          lineHeight: 10,
                                        ),
                                        StyledText(
                                          '챌린저 트레킹슈즈',
                                          fontFamily: 'Montserrat',
                                          fontWeight: 500,
                                          fontSize: 16,
                                          lineHeight: 22,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 9.0.sp),
                                          child: Row(
                                            children: [
                                              StyledText(
                                                '1,000',
                                                fontFamily: 'Montserrat',
                                                fontWeight: 600,
                                                fontSize: 22,
                                                lineHeight: 22,
                                              ),
                                              StyledText(
                                                ' STIK',
                                                fontFamily: 'Montserrat',
                                                fontWeight: 400,
                                                fontSize: 22,
                                                lineHeight: 22,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              right: 23.sp,
                              top: 18.sp,
                              child: iconArrowRightTriangle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0.sp),
              child: Divider(
                color: Color(0xFF26272F),
                height: 3,
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0.sp, left: 20.sp, right: 20.sp, bottom: 0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    '이용안내',
                    fontWeight: 500,
                    fontSize: 18,
                    lineHeight: 20,
                    letterSpacing: -.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            '챌린지 보상은 참가자들이 참가에 사용한 비용과 가자고 팀이 제공하는 추가 보상으로 구성됩니다.',
                            fontSize: 12,
                            lineHeight: 16,
                            fontWeight: 500,
                            color: deepGrayColor,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            '챌린지 리더보드는 챌린지 기간 중 유효한 운동을 한 거기를 기반으로 측정됩니다.',
                            fontSize: 12,
                            lineHeight: 16,
                            fontWeight: 500,
                            color: deepGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            '챌린지 보상은 챌린지 종료 후 누적된 운동 기록에 따라 보상이 지급되며 보상 지급은 2주 이내에 처리됩니다.',
                            fontSize: 12,
                            lineHeight: 16,
                            fontWeight: 500,
                            color: deepGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
