import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengeLeaderboard extends StatelessWidget {
  const ChallengeLeaderboard({Key? key}) : super(key: key);

  Widget renderMyRank(LeaderboardController controller) {
    RankerModel myRank = controller.myRank.value!;
    return Container(
      width: double.maxFinite,
      height: 90.sp,
      color: deepBlackColor,
      padding: EdgeInsets.only(top: 8.sp, left: 11.sp, right: 17.sp, bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          iconMyRankArrow,
          // SizedBox(
          //   width: 20,
          //   child: Text(
          //     myRank.rank.toString(),
          //     style: TextStyle(color: skyBlueColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60, minWidth: 60),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  myRank.rank!.toString(),
                  style: TextStyle(color: skyBlueColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                (myRank.profileImageUrl != null)
                    ? Container(
                        width: 44.0.sp,
                        height: 44.0.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0.sp)),
                          border: Border.all(
                            color: skyBlueColor,
                            width: 1.5.sp,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 15.sp,
                            foregroundImage: NetworkImage(myRank.profileImageUrl!),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: Colors.white,
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myRank.nickname.contains('@') ? myRank.nickname.substring(0, myRank.nickname.indexOf('@')) : myRank.nickname,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        if (myRank.additionStik != null || myRank.additionTik != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.0.sp),
                            child: Text.rich(
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 10.sp,
                                height: 11.sp / 10.sp,
                                fontWeight: FontWeight.w700,
                                color: skyBlueColor,
                              ),
                              myRank.additionStik != null
                                  ? TextSpan(
                                      text: formatDecimalPlaces(myRank.additionStik ?? 0, 9, isAutoDecimal: true),
                                      children: [
                                        const TextSpan(
                                            text: ' STIK',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                        if (myRank.additionTik != null) const TextSpan(text: ' + '),
                                        if (myRank.additionTik != null)
                                          TextSpan(
                                              text: formatDecimalPlaces(myRank.additionTik ?? 0, 0),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              )),
                                        if (myRank.additionTik != null)
                                          const TextSpan(
                                              text: ' TIK',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              )),
                                      ],
                                    )
                                  : myRank.additionTik != null
                                      ? TextSpan(
                                          text: '${myRank.additionTik ?? '0'}',
                                          children: const [
                                            TextSpan(
                                                text: ' TIK',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        )
                                      : const TextSpan(
                                          text: '',
                                        ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StyledText(
                '${formatDecimalPlaces(myRank.rewardGo, 2, isAutoDecimal: true)} GO',
                textAlign: TextAlign.right,
                fontSize: 14,
                fontWeight: 600,
              ),
              Padding(padding: EdgeInsets.only(top: 7.sp)),
              StyledText(
                '${formatDecimalPlaces(myRank.rewardTik, 0)} TIK',
                textAlign: TextAlign.right,
                color: deepGrayColor,
                fontSize: 14,
                fontWeight: 500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderRanker(RankerModel ranker, BuildContext context) {
    return Container(
      color: subBg01Color,
      height: 60.sp,
      padding: EdgeInsets.only(left: 18.sp, right: 17.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 40, minWidth: 40),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  ranker.rank!.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (ranker.profileImageUrl != null)
                      ? SizedBox(
                          width: 50.0.sp,
                          height: 50.0.sp,
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 7.0),
                                  child: CircleAvatar(
                                    radius: 16.sp,
                                    foregroundImage: (ranker.profileImageUrl == null || ranker.profileImageUrl == '')
                                        ? Image.asset(
                                            'assets/images/ic_launcher.png',
                                            width: 30.sp,
                                          ).image
                                        : NetworkImage(ranker.profileImageUrl!),
                                  ),
                                ),
                              ),
                              if (ranker.rank! < 11)
                                Center(
                                  child: SizedBox(
                                    width: 50.sp,
                                    height: 50.sp,
                                    child: Image.asset(
                                      'assets/images/leaderboard/ranker_${ranker.rank}.png',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : CircleAvatar(
                          radius: 16.sp,
                          backgroundColor: Colors.white,
                        ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (ranker.nickname.contains('@')
                                ? ranker.nickname.substring(
                                    0,
                                    ranker.nickname.indexOf('@'),
                                  )
                                : ranker.nickname),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, height: 18.sp / 16.sp, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          if (ranker.additionStik != null || ranker.additionTik != null)
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.sp),
                              child: Text.rich(
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  height: 11.sp / 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: skyBlueColor,
                                ),
                                ranker.additionStik != null
                                    ? TextSpan(
                                        text: formatDecimalPlaces(ranker.additionStik ?? 0, 9, isAutoDecimal: true),
                                        children: [
                                          const TextSpan(
                                              text: ' STIK',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              )),
                                          if (ranker.additionTik != null) const TextSpan(text: ' + '),
                                          if (ranker.additionTik != null)
                                            TextSpan(
                                                text: formatDecimalPlaces(ranker.additionTik ?? 0, 0),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          if (ranker.additionTik != null)
                                            const TextSpan(
                                                text: ' TIK',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                )),
                                        ],
                                      )
                                    : ranker.additionTik != null
                                        ? TextSpan(
                                            text: '${ranker.additionTik ?? '0'}',
                                            children: const [
                                              TextSpan(
                                                  text: ' TIK',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ],
                                          )
                                        : const TextSpan(
                                            text: '',
                                          ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StyledText(
                '${formatDecimalPlaces(ranker.rewardGo, 2, isAutoDecimal: true)} GO',
                textAlign: TextAlign.right,
                fontSize: 14,
                lineHeight: 14,
                fontWeight: 600,
                letterSpacing: -.1,
                softWrap: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.sp),
                child: StyledText(
                  '${formatDecimalPlaces(ranker.rewardTik, 0)} TIK',
                  textAlign: TextAlign.right,
                  fontSize: 14,
                  lineHeight: 14,
                  fontWeight: 500,
                  letterSpacing: -.1,
                  color: const Color(0xFFBABABA),
                  softWrap: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeaderboardController controller = Get.put(LeaderboardController());

    return Obx(() {
      return Container(
        color: subBg01Color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25.0.sp, left: 26.sp, right: 30.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StyledText(
                    '챌린지 보상',
                    color: Colors.white,
                    fontWeight: 600,
                    fontSize: 20,
                    lineHeight: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0.sp),
                    child: StyledText(
                      '분배할 전체 리워드',
                      color: deepGrayColor,
                      fontWeight: 600,
                      fontSize: 12,
                      lineHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.sp, left: 25.sp, right: 25.sp),
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
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconTodayTik,
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                StyledText(
                                  controller.todayTikAmount.value > 0 ? formatDecimalPlaces(controller.todayTikAmount.value, 0) : 0.toString(),
                                  color: Colors.white,
                                  fontWeight: 600,
                                  fontSize: 30,
                                  lineHeight: 34,
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(left: 2.0.sp),
                                //   child: const StyledText(
                                //     'TIK',
                                //     color: Colors.white,
                                //     fontWeight: 500,
                                //     fontSize: 18,
                                //     lineHeight: 20,
                                //   ),
                                // ),
                              ],
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30.sp, left: 25.sp, right: 18.sp, bottom: 12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    controller.checkRewardDate.value,
                    color: Colors.white,
                    fontSize: 20,
                    lineHeight: 20,
                    fontWeight: 600,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.sp),
                    child: InkWell(
                      onTap: () => null,
                      child: Row(
                        children: [
                          StyledText(
                            '더보기',
                            color: lightGrayColor,
                            fontSize: 14,
                            lineHeight: 16,
                            fontWeight: 600,
                            letterSpacing: -.1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0.sp),
                            child: iconArrowRightTriangle,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (controller.myRank.value != null) ? renderMyRank(controller) : Container(),
            Expanded(
              child: controller.dataGetLoading.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : controller.rankings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconEmpty,
                              Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: const StyledText(
                                  '랭킹 기록이 없어요.',
                                  color: Color(0xff7b7b7b),
                                  fontSize: 16,
                                  lineHeight: 10,
                                  fontWeight: 500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.separated(
                                controller: controller.leaderboardScrollController,
                                separatorBuilder: (context, index) => const Divider(
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                  height: 1,
                                  color: Color(0xFF26272F),
                                ),
                                itemCount: controller.rankings.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < controller.rankings.length) {
                                    return renderRanker(controller.rankings[index], context);
                                  } else {
                                    return (controller.hasMore.value)
                                        ? Padding(padding: EdgeInsets.symmetric(vertical: 20.0.sp), child: const Center(child: CircularProgressIndicator()))
                                        : Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
            )
          ],
        ),
      );
    });
  }
}
