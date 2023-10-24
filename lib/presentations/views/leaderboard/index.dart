import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/archive/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/leaderboard.dart';
import 'package:get/get.dart';

class RankingHome extends StatelessWidget {
  const RankingHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LeaderboardController controller = Get.put(LeaderboardController());

    return Scaffold(
      backgroundColor: subBg01Color,
      body: Container(
        color: subBg01Color,
        child: Column(
          children: [
            TabBar(
              controller: controller.tabController,
              padding: EdgeInsets.symmetric(horizontal: 6.sp),
              indicator: const BoxDecoration(
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
                fontSize: 16.sp,
                height: 20.sp / 16.sp,
                letterSpacing: 0.5,
              ),
              tabs: [
                Tab(
                  height: 50.sp,
                  text: '통합 리더보드',
                ),
                Tab(
                  height: 50.sp,
                  text: '운동기록',
                ),
              ],
            ),
            const Divider(
              color: Color(0xFF2E3038),
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.tabController,
                children: const [
                  LeaderboardHome(),
                  ArchiveHome(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
