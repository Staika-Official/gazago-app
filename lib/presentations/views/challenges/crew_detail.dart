import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/components/share_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class CrewDetail extends StatelessWidget {
  const CrewDetail({Key? key}) : super(key: key);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    CrewDetailController controller = Get.put(CrewDetailController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: preferredSize, // here the desired height
          child: const ShareAppbar(
            titleText: '크루 릴레이',
            isBeta: true,
            isLockButton: true,
          )),
      backgroundColor: subBg01Color,
      body: Column(
        children: [
          TabBar(
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
              fontSize: 16.sp,
              height: 20.sp / 16.sp,
              letterSpacing: 0.5,
            ),
            tabs: [
              Tab(
                height: 50.sp,
                text: '나의 크루',
              ),
              Tab(
                height: 50.sp,
                text: '크루 랭킹',
              ),
            ],
          ),
          // TabBarView(
          //   physics: const NeverScrollableScrollPhysics(),
          //   controller: controller.tabController,
          //   children: [CrewLeaderboard(), CrewLeaderboard()],
          // ),
        ],
      ),
    );
  }
}
