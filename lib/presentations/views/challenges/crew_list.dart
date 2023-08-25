import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class CrewList extends StatelessWidget {
  const CrewList({Key? key}) : super(key: key);

  List<Widget> renderCrewList(ChallengesDetailController controller) {
    return controller.crewList.map((item) {
      return Container(
        color: subBg01Color,
        height: 64.sp,
        padding: EdgeInsets.only(left: 18.sp, right: 20.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (item.iconImageUrl != null)
                        ? SizedBox(
                            width: 52.0.sp,
                            height: 52.0.sp,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 22.sp,
                                    backgroundColor: deepGrayColor,
                                    foregroundImage: (item.iconImageUrl == null || item.iconImageUrl == '')
                                        ? Image.asset(
                                            'assets/images/ic_launcher.png',
                                            width: 30.sp,
                                          ).image
                                        : NetworkImage(
                                            item.iconImageUrl!,
                                          ),
                                  ),
                                ),
                                item.isLocked!
                                    ? Positioned(
                                        right: -2,
                                        bottom: -2,
                                        child: iconCircleLock,
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : CircleAvatar(
                            radius: 22.sp,
                            backgroundColor: Colors.white,
                          ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              item.name!,
                              fontWeight: 500,
                              fontSize: 16,
                              lineHeight: 20,
                              letterSpacing: 0,
                              overflowEllipsis: true,
                            ),
                            StyledText(
                              '크루장 : ${item.crewFounderNickName!}',
                              color: deepGrayColor,
                              fontWeight: 500,
                              fontSize: 12,
                              lineHeight: 16,
                              letterSpacing: 0,
                              overflowEllipsis: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => item.isLocked! ? null : Get.toNamed(Routes.crewDetail),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: subBg01Color,
                  border: Border.all(
                    color: item.isLocked! ? deepGrayColor : skyBlueColor,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 14.0.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconPeople,
                      Padding(
                        padding: EdgeInsets.only(left: 4.0.sp),
                        child: StyledText(
                          item.user.toString(),
                          textAlign: TextAlign.right,
                          color: item.isLocked! ? deepGrayColor : Colors.white,
                          fontSize: 14,
                          lineHeight: 16,
                          fontWeight: 500,
                          letterSpacing: -.1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.find();

    return SingleChildScrollView(
      child: Obx(() {
        return Container(
            color: subBg01Color,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: controller.dataGetLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: const Center(child: CircularProgressIndicator()),
                            )
                          : controller.challengeRankingList.isEmpty
                              ? SizedBox(
                                  height: 500,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        iconEmpty,
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.sp),
                                          child: const StyledText(
                                            '크루가 없어요.',
                                            color: Color(0xff7b7b7b),
                                            fontSize: 16,
                                            lineHeight: 10,
                                            fontWeight: 500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 10.0.sp),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [...renderCrewList(controller)],
                                  ),
                                ),
                    )
                  ],
                ),
              ),
            )
            // height: MediaQuery.of(context).size.height,

            );
      }),
    );
  }
}
