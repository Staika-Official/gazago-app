import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class CrewLeaderboard extends StatelessWidget {
  const CrewLeaderboard({Key? key}) : super(key: key);

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
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 60, minWidth: 50),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: StyledText(
                          item.rank.toString(),
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: Center(
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: StyledText(
                                item.name!,
                                fontWeight: 500,
                                fontSize: 16,
                                lineHeight: 20,
                                letterSpacing: 0,
                                overflowEllipsis: true,
                              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: StyledText(
                '${item.blockQuantity} 블럭',
                textAlign: TextAlign.right,
                color: Colors.white,
                fontSize: 14,
                fontWeight: 700,
                softWrap: false,
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
      ),
    );
  }
}
