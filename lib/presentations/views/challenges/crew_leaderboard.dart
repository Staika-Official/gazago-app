import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class CrewLeaderboard extends StatelessWidget {
  const CrewLeaderboard({Key? key}) : super(key: key);

  List<Widget> renderCrewLeaderboardList(ChallengesDetailController controller) {
    return controller.crewList.asMap().entries.map((item) {
      return CrewRankingItem(item.key, item.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.find<ChallengesDetailController>();

    return Obx(() {
      return Container(
        color: subBg01Color,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              if (controller.myCrew.value != null) CrewRankingItem(controller.myCrew.value!['ranking'] - 1, controller.myCrew.value!['crew'], isMyCrew: true),
              ...renderCrewLeaderboardList(controller),
            ],
          ),
        ),
      );
    });
  }
}

class CrewRankingItem extends StatelessWidget {
  final int index;
  final CrewModel item;
  bool isMyCrew;

  CrewRankingItem(
    this.index,
    this.item, {
    this.isMyCrew = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isMyCrew ? Colors.black : subBg01Color,
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
                    constraints: const BoxConstraints(maxWidth: 50, minWidth: 40),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: StyledText(
                        (index + 1).toString(),
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
                                width: 44.sp,
                              ).image
                            : item.iconImageUrl!.contains('.svg')
                                ? sp.Svg(item.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                                : CachedNetworkImageProvider(
                                    item.iconImageUrl!,
                                    headers: imageNetworkHeader,
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
                            '크루장 : ${item.crewFounderNickName!.split('@')[0]}',
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
  }
}
