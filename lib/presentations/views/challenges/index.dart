import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengesHome extends StatelessWidget {
  const ChallengesHome({Key? key}) : super(key: key);

  List<Widget> renderChallengeList(ChallengesController controller) {
    return controller.challengeList
        .map(
          (item) => InkWell(
            onTap: () => controller.moveToDetail(item.id),
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 148.sp,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          if (item.thumbnailImageUrl != null || item.thumbnailImageUrl != '')
                            item.thumbnailImageUrl!.contains('.svg')
                                ? SvgPicture.network(
                                    fit: BoxFit.cover,
                                    item.thumbnailImageUrl!,
                                    placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                    headers: imageNetworkHeader,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: item.thumbnailImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                    errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                    httpHeaders: imageNetworkHeader,
                                  ),
                          // Image.asset("assets/images/challenges/@temp_img.png", fit: BoxFit.cover),
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
                                padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 11.0.sp),
                                child: StyledText(
                                  controller.getChallengeActivationTypeString(item.challengeActivationType),
                                  fontWeight: 600,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                              ),
                            ),
                          ),
                          if (item.challengeUserState != 'COMPLETE' && item.challengeUserState != 'INCOMPLETE')
                            Positioned(
                              bottom: 12.sp,
                              left: 15.sp,
                              child: item.challengeUserState == 'REGISTER_AVAILABLE' || item.challengeUserState == 'REGISTER_READY'
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 1.sp, color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2.sp),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 13.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: StyledText(
                                            controller.getChallengeUserStatus(item.challengeUserState!),
                                            fontWeight: 700,
                                            fontSize: 12,
                                            lineHeight: 14,
                                            color: Colors.black.withOpacity(.6),
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ),
                                    )
                                  : item.challengeUserState != null
                                      ? Container(
                                          width: 70,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: item.challengeUserState == 'JOINED'
                                                  ? const sp.Svg('assets/images/challenges/bg_challenge_user_state_skyblue.svg')
                                                  : item.challengeUserState == 'JOIN_AVAILABLE'
                                                      ? const sp.Svg('assets/images/challenges/bg_challenge_user_state_white.svg')
                                                      : const sp.Svg('assets/images/challenges/bg_challenge_user_state_gray.svg'), // 배경 이미지/ 배경 이미지
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 13.0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: StyledText(
                                                controller.getChallengeUserStatus(item.challengeUserState!),
                                                fontWeight: 700,
                                                fontSize: 12,
                                                lineHeight: 14,
                                                color: Colors.black,
                                                letterSpacing: -.1,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                            ),
                          if (item.challengeUserState == 'COMPLETE' || item.challengeUserState == 'INCOMPLETE')
                            Positioned(
                              right: 5.sp,
                              bottom: -30.sp,
                              child: item.challengeUserState == 'COMPLETE' ? iconChallengeSuccess : iconChallengeFailure,
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 114.sp,
                      child: Padding(
                        padding: EdgeInsets.all(11.0.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0.sp),
                              child: StyledText(
                                item.subTitle!,
                                fontSize: 12,
                                lineHeight: 13,
                                fontWeight: 500,
                                overflowEllipsis: true,
                                color: lightGrayColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0.sp),
                              child: StyledText(
                                item.title,
                                fontSize: 18,
                                lineHeight: 20,
                                fontWeight: 500,
                                overflowEllipsis: true,
                              ),
                            ),
                            Row(
                              children: [
                                StyledText(
                                  '${formatDateUntilDay(item.fromDate)} - ${formatDateUntilDay(item.toDate)}',
                                  color: lightGrayColor,
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0.sp),
                                  child: StyledText(
                                    ' · ',
                                    color: lightGrayColor,
                                    fontWeight: 500,
                                    fontSize: 12,
                                    lineHeight: 14,
                                    letterSpacing: -.1,
                                  ),
                                ),
                                StyledText(
                                  controller.getChallengeStatus(item.challengeState!),
                                  color: item.challengeState == 'READY'
                                      ? lightGreenColor
                                      : item.challengeState == 'IN_PROGRESS'
                                          ? skyBlueColor
                                          : lightGrayColor,
                                  fontWeight: 500,
                                  fontSize: 12,
                                  lineHeight: 14,
                                  letterSpacing: -.1,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.sp),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      ...item.exerciseTypes!.map(
                                        (type) => Padding(
                                          padding: EdgeInsets.only(right: 5.0.sp),
                                          child: Container(
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
                                                controller.getChallengeExerciseType(type),
                                                color: subBg01Color,
                                                fontSize: 10,
                                                fontWeight: 600,
                                                lineHeight: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5.0.sp),
                                    child: const StyledText(
                                      ' · ',
                                      color: Color(0xffd9d9d9),
                                      fontWeight: 500,
                                      fontSize: 16,
                                      lineHeight: 18,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      iconPeople,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Row(
                                          children: [
                                            item.challengeState == 'READY'
                                                ? StyledText(
                                                    '모집인원',
                                                    color: lightGrayColor,
                                                    fontWeight: 500,
                                                    fontSize: 12,
                                                    lineHeight: 13,
                                                    letterSpacing: -.1,
                                                  )
                                                : StyledText(
                                                    '${formatDecimalPlaces((item.soldQuantity ?? 0).toDouble(), 0)}명',
                                                    color: lightGrayColor,
                                                    fontWeight: 500,
                                                    fontSize: 12,
                                                    lineHeight: 13,
                                                    letterSpacing: -.1,
                                                  ),
                                            StyledText(
                                              item.quantity >= 0
                                                  ? '${item.challengeState == 'READY' ? '' : ' /'} ${formatDecimalPlaces(item.quantity.toDouble(), 0)}명'
                                                  : item.challengeState == 'READY'
                                                      ? ' 제한없음'
                                                      : ' 참여중',
                                              color: lightGrayColor,
                                              fontWeight: 500,
                                              fontSize: 12,
                                              lineHeight: 13,
                                              letterSpacing: -.1,
                                            ),
                                          ],
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
        padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 12.sp),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(bottom: 14.0.sp),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       InkWell(
              //         onTap: () => challengesController.showChallengesSortingPopup(),
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: popupBgColor,
              //             border: Border.all(
              //               width: 1,
              //               color: Colors.black,
              //             ),
              //             borderRadius: const BorderRadius.all(
              //               Radius.circular(100),
              //             ),
              //             boxShadow: const [
              //               BoxShadow(
              //                 color: Colors.black,
              //                 offset: Offset(1, 0),
              //                 blurRadius: 0.0,
              //                 spreadRadius: 0.0,
              //               ),
              //             ],
              //           ),
              //           child: Stack(
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 18.0.sp, top: 11.sp, bottom: 11.sp, right: 58.sp),
              //                 child: StyledText(
              //                   challengesController.isSelectedSortString.value,
              //                   fontWeight: 500,
              //                   fontSize: 14,
              //                 ),
              //               ),
              //               Positioned(
              //                 right: 15.sp,
              //                 top: 14.sp,
              //                 child: iconArrowDown,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           if (challengesController.isSelectAllItems.value)
              //             Padding(
              //               padding: EdgeInsets.only(right: 10.0.sp),
              //               child: StyledText(
              //                 '전체',
              //                 fontWeight: 600,
              //                 fontSize: 14,
              //                 lineHeight: 22,
              //                 color: lightGrayColor,
              //               ),
              //             ),
              //           InkWell(
              //             onTap: () => challengesController.showChallengesFilterPopup(),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: popupBgColor,
              //                 border: Border.all(
              //                   width: 1.sp,
              //                   color: Colors.black,
              //                 ),
              //                 borderRadius: BorderRadius.all(
              //                   Radius.circular(5.sp),
              //                 ),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black,
              //                     offset: Offset(2.sp, 2.sp),
              //                     blurRadius: 0.0,
              //                     spreadRadius: 0.0,
              //                   ),
              //                 ],
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
              //                 child: challengesController.isSelectAllItems.value ? iconShopFilter : iconShopFilterActive,
              //               ),
              //             ),
              //           )
              //         ],
              //       )
              //     ],
              //   ),
              // ),

              challengesController.challengeList.isEmpty
                  ? challengesController.dataGetLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 120.0.sp),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          width: double.infinity,
                          height: 248.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: popupBgColor,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconNoneChallenges,
                              Padding(
                                padding: EdgeInsets.only(top: 22.0.sp),
                                child: StyledText(
                                  '진행중인 챌린지가 없습니다\n빠른시일에 만나요!',
                                  color: deepGrayColor,
                                  fontSize: 16,
                                  lineHeight: 20,
                                  fontWeight: 500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
