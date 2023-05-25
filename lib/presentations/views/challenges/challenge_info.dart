import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ChallengeInfo extends StatelessWidget {
  const ChallengeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.find();

    return SingleChildScrollView(
      child: Obx(() {
        return Container(
          color: subBg01Color,
          padding: EdgeInsets.only(bottom: 120.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 20.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (controller.challengeDetails.value.introduce != null)
                      Html(
                        data: controller.challengeDetails.value.introduce!,
                        style: {
                          "p": Style(
                            color: Colors.white,
                          ),
                          "strong": Style(
                            color: Colors.white,
                          ),
                          "*": Style(
                            color: Colors.white,
                          ),
                        },
                      ),
                    // StyledText(
                    //   controller.challengeDetails.value.description!,
                    //   fontWeight: 500,
                    //   fontSize: 18,
                    //   lineHeight: 20,
                    //   letterSpacing: -.1,
                    // ),
                    // StyledText(
                    //   '챌린지 스토리',
                    //   fontWeight: 500,
                    //   fontSize: 18,
                    //   lineHeight: 20,
                    //   letterSpacing: -.1,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 12.0.sp),
                    //   child: StyledText(
                    //     '5월 첫째주, 새롭게 출시된  Epic 등급의 챌린저 트레킹슈즈를 신고 최대한 많이 걸어보세요. 매일의 순위는 챌린지 리더보드에서 확인하실 수 있습니다. 챌린지 기간 종료 후 누적 거리가 50km 미만이라면 보상이 지급되지 않습니다.',
                    //     fontWeight: 500,
                    //     fontSize: 14,
                    //     lineHeight: 22,
                    //     letterSpacing: -.1,
                    //   ),
                    // ),
                    if (controller.challengeDetails.value.minDistance != null && controller.challengeDetails.value.minDistance! > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 38.0.sp, bottom: 8.sp),
                            child: StyledText(
                              '최소 거리 조건',
                              fontWeight: 500,
                              fontSize: 18,
                              lineHeight: 20,
                              letterSpacing: -.1,
                            ),
                          ),
                          StyledText(
                            '${controller.challengeDetails.value.minDistance!.toString()} km',
                            color: deepGrayColor,
                            fontSize: 14,
                            fontWeight: 500,
                            lineHeight: 14,
                            letterSpacing: -.1,
                          ),
                        ],
                      ),

                    Padding(
                      padding: EdgeInsets.only(top: 40.0.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StyledText(
                            '챌린지 보상',
                            fontWeight: 500,
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: -.1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: StyledText(
                              '분배할 전체 리워드',
                              color: deepGrayColor,
                              fontSize: 14,
                              fontWeight: 500,
                              lineHeight: 14,
                              letterSpacing: -.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.sp),
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
                        padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            iconTodayTik,
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.challengeDetails.value.rewardAmount != null)
                                    StyledText(
                                      formatDecimalPlaces(double.parse(controller.challengeDetails.value.rewardAmount!.toString()), 0),
                                      color: Colors.white,
                                      fontWeight: 600,
                                      fontSize: 26,
                                      lineHeight: 28,
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0.sp),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StyledText(
                            '챌린지 참가 조건',
                            fontWeight: 500,
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: -.1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: StyledText(
                              controller.challengeDetails.value.challengeActivationType == 'ITEM' ? '아이템 장착' : '',
                              color: deepGrayColor,
                              fontSize: 14,
                              fontWeight: 500,
                              lineHeight: 14,
                              letterSpacing: -.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.sp),
                      child: InkWell(
                        onTap: () {
                          if (!(controller.challengeDetails.value.challengeState == 'READY' && controller.challengeDetails.value.challengeUserState == 'REGISTER_READY') ||
                              !(controller.challengeDetails.value.challengeState == 'CLOSED')) {
                            if (Get.previousRoute == Routes.shopItemDetail) {
                              Get.back();
                            } else {
                              Get.toNamed(Routes.shopItemDetail, arguments: {'id': controller.challengeDetails.value.itemTradeStoreId!});
                            }

                            // controller.moveShopDetail();
                          }
                        },
                        child: Container(
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
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 10.sp),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (controller.challengeDetails.value.item != null)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: subBg01Color,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.sp),
                                          ),
                                        ),
                                        width: 107.sp,
                                        height: 87.sp,
                                        // item.itemImageUrl!.contains('.svg')
                                        // ? SvgPicture.network(
                                        // fit: BoxFit.contain,
                                        // item.itemImageUrl!,
                                        // placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                        // )
                                        //     : CachedNetworkImage(
                                        // imageUrl: item.itemImageUrl!,
                                        // fit: BoxFit.fitHeight,
                                        // placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                        // errorWidget: (context, url, error) => Image.asset("assets/images/@temp_bal.png"),
                                        // )
                                        child: controller.challengeDetails.value.item!.itemImageUrl!.contains('.svg')
                                            ? SvgPicture.network(
                                                fit: BoxFit.contain,
                                                controller.challengeDetails.value.item!.itemImageUrl!,
                                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: controller.challengeDetails.value.item!.itemImageUrl!,
                                                fit: BoxFit.fitHeight,
                                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                              ),
                                      ),
                                    if (controller.challengeDetails.value.item != null)
                                      Padding(
                                        padding: EdgeInsets.only(left: 17.0.sp),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (controller.challengeDetails.value.item!.itemLabel != null)
                                              StyledText(
                                                controller.challengeDetails.value.item!.itemLabel == 'CLOSE_DEADLINE' ? '마감임박' : '품절',
                                                color: skyBlueColor,
                                                fontWeight: 600,
                                                fontSize: 10,
                                                lineHeight: 10,
                                              ),
                                            StyledText(
                                              controller.challengeDetails.value.item!.name,
                                              fontFamily: 'Montserrat',
                                              fontWeight: 500,
                                              fontSize: 16,
                                              lineHeight: 22,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 9.0.sp),
                                              child: Row(
                                                children: [
                                                  StyledText(
                                                    formatDecimalPlaces(controller.challengeDetails.value.item!.price, 0),
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: 600,
                                                    fontSize: 22,
                                                    lineHeight: 22,
                                                  ),
                                                  StyledText(
                                                    ' ${controller.challengeDetails.value.item!.tradeSymbol}',
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: 400,
                                                    fontSize: 22,
                                                    lineHeight: 22,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 23.sp,
                                top: 18.sp,
                                child: iconArrowRightTriangle,
                              ),
                              if ((controller.challengeDetails.value.challengeState == 'READY' && controller.challengeDetails.value.challengeUserState == 'REGISTER_READY') ||
                                  controller.challengeDetails.value.challengeState == 'CLOSED')
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0.sp),
                child: Divider(
                  color: Color(0xFF26272F),
                  height: 3,
                  thickness: 2,
                ),
              ),
              if (controller.challengeDetails.value.description != null)
                Padding(
                  padding: EdgeInsets.only(top: 30.0.sp, left: 20.sp, right: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        '이용안내',
                        fontWeight: 500,
                        fontSize: 18,
                        lineHeight: 20,
                        letterSpacing: -.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Html(
                          data: controller.challengeDetails.value.description!,
                          style: {
                            "*": Style(
                              color: Colors.white,
                            ),
                            "p": Style(
                              color: Colors.white,
                            ),
                            "strong": Style(
                              color: Colors.white,
                            ),
                          },
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
