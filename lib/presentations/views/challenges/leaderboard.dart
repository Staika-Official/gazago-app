import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_ranker_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengeLeaderboard extends StatelessWidget {
  const ChallengeLeaderboard({super.key});

  Widget renderMyRank(ChallengesDetailController controller) {
    ChallengeRankerModel myRank = controller.myRank.value!;
    return Container(
      width: double.maxFinite,
      height: 90.sp,
      color: deepBlackColor,
      padding: EdgeInsets.only(top: 8.sp, left: 11.sp, right: 17.sp, bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          iconMyRankArrow,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 60, minWidth: 50),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
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
                            foregroundImage: (myRank.profileImageUrl == null || myRank.profileImageUrl == '')
                                ? Image.asset(
                                    'assets/images/ic_launcher.png',
                                    width: 30.sp,
                                  ).image
                                : NetworkImage(
                                    myRank.profileImageUrl!,
                                    headers: imageNetworkHeader,
                                  ),
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
                        if (myRank.nickname != null)
                          Text(
                            myRank.nickname!.contains('@') ? myRank.nickname!.substring(0, myRank.nickname!.indexOf('@')) : myRank.nickname!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        // if (myRank.additionStik != null || myRank.additionTik != null)
                        //   Padding(
                        //     padding: EdgeInsets.only(top: 4.0.sp),
                        //     child: Text.rich(
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //         fontSize: 10.sp,
                        //         height: 11.sp / 10.sp,
                        //         fontWeight: FontWeight.w700,
                        //         color: skyBlueColor,
                        //       ),
                        //       myRank.additionStik != null
                        //           ? TextSpan(
                        //               text: formatDecimalPlaces(myRank.additionStik ?? 0, 9, isAutoDecimal: true),
                        //               children: [
                        //                 const TextSpan(
                        //                     text: ' STIK',
                        //                     style: TextStyle(
                        //                       fontWeight: FontWeight.w400,
                        //                     )),
                        //                 if (myRank.additionTik != null) const TextSpan(text: ' + '),
                        //                 if (myRank.additionTik != null)
                        //                   TextSpan(
                        //                       text: formatDecimalPlaces(myRank.additionTik ?? 0, 0),
                        //                       style: const TextStyle(
                        //                         fontWeight: FontWeight.w700,
                        //                       )),
                        //                 if (myRank.additionTik != null)
                        //                   const TextSpan(
                        //                       text: ' TIK',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w400,
                        //                       )),
                        //               ],
                        //             )
                        //           : myRank.additionTik != null
                        //               ? TextSpan(
                        //                   text: '${myRank.additionTik ?? '0'}',
                        //                   children: const [
                        //                     TextSpan(
                        //                         text: ' TIK',
                        //                         style: TextStyle(
                        //                           fontWeight: FontWeight.w400,
                        //                         )),
                        //                   ],
                        //                 )
                        //               : const TextSpan(
                        //                   text: '',
                        //                 ),
                        //     ),
                        //   )
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
                '${formatMeterToKilometer(myRank.rewardDistance)} km',
                textAlign: TextAlign.right,
                fontSize: 16,
                fontWeight: 700,
              ),
              // Padding(padding: EdgeInsets.only(top: 7.sp)),
              // StyledText(
              //   '${formatDecimalPlaces(myRank.rewardTik, 0)} TIK',
              //   textAlign: TextAlign.right,
              //   color: deepGrayColor,
              //   fontSize: 14,
              //   fontWeight: 500,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> renderRanker(ChallengesDetailController controller) {
    return controller.challengeRankingList.map((item) {
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
              constraints: const BoxConstraints(maxWidth: 40, minWidth: 40),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    item.rank!.toString(),
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
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (item.profileImageUrl != null)
                        ? SizedBox(
                            width: 50.0.sp,
                            height: 50.0.sp,
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: CircleAvatar(
                                      radius: 16.sp,
                                      foregroundImage: (item.profileImageUrl == null || item.profileImageUrl == '')
                                          ? Image.asset(
                                              'assets/images/ic_launcher.png',
                                              width: 30.sp,
                                            ).image
                                          : NetworkImage(
                                              item.profileImageUrl!,
                                              headers: imageNetworkHeader,
                                            ),
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ),
                                if (item.rank! < 11)
                                  Center(
                                    child: SizedBox(
                                      width: 50.sp,
                                      height: 50.sp,
                                      child: Image.asset(
                                        'assets/images/leaderboard/ranker_${item.rank}.png',
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
                              (item.nickname!.contains('@')
                                  ? item.nickname!.substring(
                                      0,
                                      item.nickname!.indexOf('@'),
                                    )
                                  : item.nickname!),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 16.sp, height: 18.sp / 16.sp, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            // if (item.additionStik != null || item.additionTik != null)
                            //   Padding(
                            //     padding: EdgeInsets.only(top: 2.0.sp),
                            //     child: Text.rich(
                            //       textAlign: TextAlign.start,
                            //       style: TextStyle(
                            //         fontSize: 10.sp,
                            //         height: 11.sp / 10.sp,
                            //         fontWeight: FontWeight.w700,
                            //         color: skyBlueColor,
                            //       ),
                            //       item.additionStik != null
                            //           ? TextSpan(
                            //               text: formatDecimalPlaces(item.additionStik ?? 0, 9, isAutoDecimal: true),
                            //               children: [
                            //                 const TextSpan(
                            //                     text: ' STIK',
                            //                     style: TextStyle(
                            //                       fontWeight: FontWeight.w400,
                            //                     )),
                            //                 if (item.additionTik != null) const TextSpan(text: ' + '),
                            //                 if (item.additionTik != null)
                            //                   TextSpan(
                            //                       text: formatDecimalPlaces(item.additionTik ?? 0, 0),
                            //                       style: const TextStyle(
                            //                         fontWeight: FontWeight.w700,
                            //                       )),
                            //                 if (item.additionTik != null)
                            //                   const TextSpan(
                            //                       text: ' TIK',
                            //                       style: TextStyle(
                            //                         fontWeight: FontWeight.w400,
                            //                       )),
                            //               ],
                            //             )
                            //           : item.additionTik != null
                            //               ? TextSpan(
                            //                   text: '${item.additionTik ?? '0'}',
                            //                   children: const [
                            //                     TextSpan(
                            //                         text: ' TIK',
                            //                         style: TextStyle(
                            //                           fontWeight: FontWeight.w400,
                            //                         )),
                            //                   ],
                            //                 )
                            //               : const TextSpan(
                            //                   text: '',
                            //                 ),
                            //     ),
                            //   )
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
                  '${formatMeterToKilometer(item.rewardDistance)} km',
                  textAlign: TextAlign.right,
                  fontSize: 16,
                  lineHeight: 14,
                  fontWeight: 700,
                  letterSpacing: -.1,
                  softWrap: false,
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 3.sp),
                //   child: StyledText(
                //     '${formatDecimalPlaces(item.rewardTik, 0)} TIK',
                //     textAlign: TextAlign.right,
                //     fontSize: 14,
                //     lineHeight: 14,
                //     fontWeight: 500,
                //     letterSpacing: -.1,
                //     color: const Color(0xFFBABABA),
                //     softWrap: false,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.isRegistered<ChallengesDetailController>() ? Get.find() : Get.put(ChallengesDetailController());

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
                    if (controller.challengeDetails.value.rewardAmount! > 0) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 25.0.sp, left: 20.sp, right: 20.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const StyledText(
                              '챌린지 보상',
                              color: Colors.white,
                              fontWeight: 600,
                              fontSize: 20,
                              lineHeight: 24,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.0.sp),
                              child: const StyledText(
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
                        margin: EdgeInsets.only(top: 8.sp, left: 20.sp, right: 20.sp),
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
                              if (controller.challengeDetails.value.rewardAmount != null)
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      StyledText(
                                        formatDecimalPlaces(double.parse(controller.challengeDetails.value.rewardAmount!.toString()), 0),
                                        color: Colors.white,
                                        fontWeight: 600,
                                        fontSize: 30,
                                        lineHeight: 34,
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                    Container(
                      padding: EdgeInsets.only(top: 30.sp, left: 20.sp, right: 20.sp, bottom: 12.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const StyledText(
                            '실시간 TOP100',
                            color: Colors.white,
                            fontSize: 16,
                            lineHeight: 16,
                            fontWeight: 600,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.sp),
                            child: InkWell(
                              onTap: () => Get.toNamed(Routes.webView, arguments: {'linkUrl': '${F.leaderboardUrl}/challenge/${controller.challengeDetails.value.id}'}),
                              child: Row(
                                children: [
                                  const StyledText(
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
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [...renderRanker(controller)],
                    // )
                    Container(
                      child: controller.dataGetLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: const Center(child: CircularProgressIndicator(color:skyBlueColor)),
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
                                            '랭킹 기록이 없어요.',
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
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [...renderRanker(controller)],
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
