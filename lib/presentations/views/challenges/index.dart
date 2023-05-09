import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengesHome extends StatelessWidget {
  const ChallengesHome({Key? key}) : super(key: key);

  List<Widget> renderChallengeList(ChallengesController controller) {
    return controller.challengeList
        .map(
          (archive) => InkWell(
            onTap: () => Get.toNamed(Routes.challengeDetail),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.sp),
              decoration: BoxDecoration(
                color: subBg02Color,
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 4.sp), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                color: popupBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 148.sp,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset("assets/images/challenges/@temp_img.png", fit: BoxFit.cover),
                          Positioned(
                            top: 12.sp,
                            left: 15.sp,
                            child: Container(
                              decoration: BoxDecoration(
                                color: subBg01Color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.sp),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
                                child: StyledText(
                                  '아이템 장착형',
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12.sp,
                            left: 15.sp,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1.sp, color: Colors.black),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.sp),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 13.0),
                                child: StyledText(
                                  '접수 중',
                                  fontWeight: 600,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  color: Colors.black.withOpacity(.6),
                                  letterSpacing: -.1,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5.sp,
                            bottom: -30.sp,
                            child: iconChallengeSuccess,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100.sp,
                      child: Padding(
                        padding: EdgeInsets.all(11.0.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StyledText(
                                  '2023/02/01 - 2023/02/01',
                                  color: lightGrayColor,
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                                StyledText(
                                  ' · ',
                                  color: lightGrayColor,
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                                StyledText(
                                  '오픈예정',
                                  color: lightGreenColor,
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0.sp),
                              child: StyledText(
                                '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
                                fontSize: 18,
                                lineHeight: 20,
                                fontWeight: 500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(width: 1.sp, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.sp),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 8.sp),
                                          child: StyledText(
                                            '걷기',
                                            color: subBg01Color,
                                            fontSize: 10,
                                            fontWeight: 500,
                                            lineHeight: 12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(width: 1.sp, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.sp),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 8.sp),
                                          child: StyledText(
                                            '100대 명산',
                                            color: subBg01Color,
                                            fontSize: 10,
                                            fontWeight: 500,
                                            lineHeight: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StyledText(
                                    ' · ',
                                    color: const Color(0xffd9d9d9),
                                    fontWeight: 500,
                                    fontSize: 16,
                                    lineHeight: 18,
                                    letterSpacing: -.1,
                                  ),
                                  Row(
                                    children: [
                                      iconPeople,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: StyledText(
                                          '80명 / 100명',
                                          color: lightGrayColor,
                                          fontWeight: 500,
                                          fontSize: 12,
                                          lineHeight: 13,
                                          letterSpacing: -.1,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
    ChallengesController challengesController = Get.put(ChallengesController());
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(left: 23.sp, right: 23.sp),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 14.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => challengesController.showChallengesSortingPopup(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: popupBgColor,
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 18.0.sp, top: 11.sp, bottom: 11.sp, right: 58.sp),
                              child: StyledText(
                                challengesController.isSelectedSortString.value,
                                fontWeight: 500,
                                fontSize: 14,
                              ),
                            ),
                            Positioned(
                              right: 15.sp,
                              top: 14.sp,
                              child: iconArrowDown,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (challengesController.isSelectAllItems.value)
                          Padding(
                            padding: EdgeInsets.only(right: 10.0.sp),
                            child: StyledText(
                              '전체',
                              fontWeight: 600,
                              fontSize: 14,
                              lineHeight: 22,
                              color: lightGrayColor,
                            ),
                          ),
                        InkWell(
                          onTap: () => challengesController.showChallengesFilterPopup(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: popupBgColor,
                              border: Border.all(
                                width: 1.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.sp),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(2.sp, 2.sp),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
                              child: challengesController.isSelectAllItems.value ? iconShopFilter : iconShopFilterActive,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              challengesController.challengeList.isEmpty
                  ? challengesController.dataGetLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 120.0.sp),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 120.sp),
                          decoration: BoxDecoration(
                            color: popupBgColor,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconShopEmpty,
                              Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: StyledText(
                                  '필터결과를 찾을 수 없습니다.',
                                  color: lightGrayColor,
                                  fontSize: 16,
                                  lineHeight: 18,
                                  fontWeight: 500,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50.0.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            runSpacing: 10.0,
                                            spacing: 10.0,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            children: [
                                              ...challengesController.filteredStatus.asMap().entries.map(
                                                    (entry) => Container(
                                                      decoration: BoxDecoration(
                                                        color: popupBgColor,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                        borderRadius: BorderRadius.circular(20.sp),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                                                        child: StyledText(
                                                          challengesController.exerciseTypeFilterList.firstWhere((element) => element['value'] == entry.value)['title']!,
                                                          fontSize: 14,
                                                          lineHeight: 16,
                                                          letterSpacing: .2,
                                                          fontWeight: 500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.0.sp),
                          child: Column(
                            children: [
                              ...renderChallengeList(challengesController),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
