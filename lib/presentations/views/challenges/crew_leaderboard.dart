import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class CrewLeaderboard extends StatelessWidget {
  const CrewLeaderboard({Key? key}) : super(key: key);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  List<Widget> renderCrewLeaderboardList(CrewDetailController controller) {
    return controller.crewLeaderboardList.map((item) {
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
              onTap: () => null,
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
    CrewDetailController controller = Get.put(CrewDetailController());

    return SingleChildScrollView(
        child: Column(
      children: [...renderCrewLeaderboardList(controller)],
    ));
  }
}
