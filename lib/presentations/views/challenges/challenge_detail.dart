import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/challenges/challenge_info.dart';
import 'package:get/get.dart';
import 'package:intrinsic_dimension/intrinsic_dimension.dart';

class ChallengeDetail extends StatelessWidget {
  const ChallengeDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.put(ChallengesDetailController());

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const SecondaryAppbar(
          isShowBackButton: true,
          isShowPreferencesButton: false,
        ),
        backgroundColor: subBg01Color,
        body: Stack(
          children: [
            IntrinsicDimension(
              listener: (_, __, height, ___) {
                print(height);
                print(_.height);
                print(__);
                print(___);
                controller.backgroundBoxSize.value = height + kToolbarHeight;
              },
              builder: (_, __, ___, ____) => Container(
                color: subBg01Color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 290.sp,
                      child: Image.asset("assets/images/challenges/@temp_img_big.png", fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.sp),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 11.0.sp),
                              child: StyledText(
                                '아이템 장착형',
                                fontWeight: 500,
                                fontSize: 12,
                                lineHeight: 14,
                                color: Colors.black,
                                letterSpacing: -.1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0.sp, bottom: 10.0.sp),
                            child: StyledText(
                              '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
                              fontSize: 20,
                              lineHeight: 23,
                              fontWeight: 500,
                              letterSpacing: -.1,
                            ),
                          ),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomScrollView(
              controller: controller.challengeDetailScrollController,
              slivers: [
                SliverAppBar(
                  // onStretchTrigger: () => controller.getSize(),
                  // collapsedHeight: 0.0,
                  backgroundColor: subBg01Color,
                  titleSpacing: 0,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: true,
                  expandedHeight: controller.backgroundBoxSize.value,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    expandedTitleScale: 1,
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      decoration: BoxDecoration(
                        color: subBg01Color,
                        border: Border(
                          top: BorderSide(
                            // POINT
                            color: const Color(0xFF2E3038),
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            // POINT
                            color: const Color(0xFF2E3038),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: controller.tabController,
                        padding: EdgeInsets.symmetric(horizontal: 6.sp),
                        indicator: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                            color: skyBlueColor,
                            width: 2,
                          )),
                        ),
                        indicatorPadding: EdgeInsets.only(left: 33.sp, right: 33.sp),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFFA5A5A5),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          height: 20.sp / 18.sp,
                          letterSpacing: 0.5,
                        ),
                        tabs: [
                          Tab(
                            text: '챌린지 안내',
                          ),
                          Tab(
                            text: '리더보드',
                          ),
                        ],
                      ),
                    ),
                    background: Container(
                      key: controller.backgroundKey,
                      color: subBg01Color,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 290.sp,
                            child: Image.asset("assets/images/challenges/@temp_img_big.png", fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.sp),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 11.0.sp),
                                    child: StyledText(
                                      '아이템 장착형',
                                      fontWeight: 500,
                                      fontSize: 12,
                                      lineHeight: 14,
                                      color: Colors.black,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0.sp, bottom: 10.0.sp),
                                  child: StyledText(
                                    '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
                                    fontSize: 20,
                                    lineHeight: 23,
                                    fontWeight: 500,
                                    letterSpacing: -.1,
                                  ),
                                ),
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller.tabController,
                    children: [ChallengeInfo(), Container(color: Colors.green, height: 200.0)],
                  ),
                ),
              ],
            ),
            // Positioned.fill(
            //   top: null,
            //   left: 0,
            //   bottom: 0,
            //   child: Container(
            //     color: Colors.red,
            //     width: double.infinity,
            //     height: 50,
            //     child: StyledText('asd'),
            //   ),
            // )
          ],
        ),
      );
    });
  }
}
