import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
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
          padding: EdgeInsets.only(bottom: 180.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.challengeDetails.value.usedImageContent != null)
                Padding(
                  padding: EdgeInsets.only(left: controller.challengeDetails.value.usedImageContent! ? 0 :20.0.sp, right: controller.challengeDetails.value.usedImageContent!? 0 : 20.0.sp, top: 20.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (controller.challengeDetails.value.introduce != null)
                        Html(
                          shrinkWrap: true,
                          data: controller.challengeDetails.value.introduce!,
                          style: {
                            "*": Style(
                              lineHeight: LineHeight.percent(130),
                            ),
                            'img': Style(
                              margin: Margins(
                                left: Margin(-5.sp),
                                right: Margin(-5.sp),
                              ),
                            ),
                            "p": Style(
                              margin: Margins.zero,
                              color: Colors.white,
                              lineHeight: LineHeight.percent(130),
                            ),
                          },
                        ),
                      if(!controller.challengeDetails.value.usedImageContent! )
                        Column(
                          children: [
                            if (controller.challengeDetails.value.rewardAmount != null && controller.challengeDetails.value.rewardAmount! > 0 || controller.challengeDetails.value.badge != null)
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 45.0.sp),
                                  child:  const StyledText(
                                    '챌린지 전체 보상',
                                    fontWeight: 500,
                                    fontSize: 18,
                                    lineHeight: 20,
                                    letterSpacing: -.1,
                                  ),
                                ),

                                if (controller.challengeDetails.value.rewardAmount != null && controller.challengeDetails.value.rewardAmount! > 0)
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0.sp),
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
                                  ),

                                if (controller.challengeDetails.value.badge != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0.sp),
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
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 10.sp),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: subBg01Color,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.sp),
                                                ),
                                              ),
                                              width: 107.sp,
                                              height: 87.sp,
                                              child: controller.challengeDetails.value.badge!.imageUrl != null
                                                  ? controller.challengeDetails.value.badge!.imageUrl!.contains('.svg')
                                                  ? SvgPicture.network(
                                                fit: BoxFit.contain,
                                                controller.challengeDetails.value.badge!.imageUrl!,
                                                placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                headers: imageNetworkHeader,
                                              )
                                                  : CachedNetworkImage(
                                                imageUrl: controller.challengeDetails.value.badge!.imageUrl!,
                                                fit: BoxFit.fitHeight,
                                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                httpHeaders: imageNetworkHeader,
                                              )
                                                  : const SizedBox(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 17.0.sp),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  StyledText(
                                                    controller.challengeDetails.value.badge!.name!,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: 500,
                                                    fontSize: 16,
                                                    lineHeight: 22,
                                                    letterSpacing: -.1,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 9.0.sp),
                                                    child: Row(
                                                      children: [
                                                        controller.challengeDetails.value.badge!.limitedCount! > 0
                                                            ? StyledText(
                                                          '${formatDecimalPlaces(controller.challengeDetails.value.badge!.limitedCount!.toDouble(), 0)} 명',
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: 600,
                                                          fontSize: 22,
                                                          lineHeight: 22,
                                                          letterSpacing: -.1,
                                                        )
                                                            : const StyledText(
                                                          '참여자 전원 뱃지 지급',
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: 600,
                                                          fontSize: 16,
                                                          lineHeight: 17,
                                                          letterSpacing: -.1,
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
                                    ),
                                  ),
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 45.0.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const StyledText(
                                        '챌린지 참가 조건',
                                        fontWeight: 500,
                                        fontSize: 18,
                                        lineHeight: 20,
                                        letterSpacing: -.1,
                                      ),
                                      controller.challengeDetails.value.challengeActivationType == 'CODE'
                                          ? Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: StyledText(
                                          '참여코드 입력',
                                          color: deepGrayColor,
                                          fontSize: 14,
                                          fontWeight: 500,
                                          lineHeight: 14,
                                          letterSpacing: -.1,
                                        ),
                                      )
                                          : Padding(
                                        padding: EdgeInsets.only(left: 3.0.sp),
                                        child: StyledText(
                                          controller.challengeDetails.value.challengeActivationType == 'ITEM' ? '아이템 장착' : '참가비 납부',
                                          color: deepGrayColor,
                                          fontSize: 14,
                                          fontWeight: 500,
                                          lineHeight: 14,
                                          letterSpacing: -.1,
                                        ),
                                      )
                                    ],
                                  ),
                                  if (controller.challengeDetails.value.item != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.0.sp),
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: subBg01Color,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(12.sp),
                                                      ),
                                                    ),
                                                    width: 107.sp,
                                                    height: 87.sp,
                                                    child: controller.challengeDetails.value.item!.itemImageUrl!.contains('.svg')
                                                        ? SvgPicture.network(
                                                      fit: BoxFit.contain,
                                                      controller.challengeDetails.value.item!.itemImageUrl!,
                                                      placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                                      headers: imageNetworkHeader,
                                                    )
                                                        : CachedNetworkImage(
                                                      imageUrl: controller.challengeDetails.value.item!.itemImageUrl!,
                                                      fit: BoxFit.fitHeight,
                                                      placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                      errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                      httpHeaders: imageNetworkHeader,
                                                    ),
                                                  ),
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
                                            // Positioned(
                                            //   right: 23.sp,
                                            //   top: 18.sp,
                                            //   child: iconArrowRightTriangle,
                                            // ),
                                            // if ((controller.challengeDetails.value.challengeState == 'READY' && controller.challengeDetails.value.challengeUserState == 'REGISTER_READY') ||
                                            //     controller.challengeDetails.value.challengeState == 'CLOSED')
                                            //   Positioned(
                                            //     left: 0,
                                            //     top: 0,
                                            //     right: 0,
                                            //     bottom: 0,
                                            //     child: Container(
                                            //       decoration: BoxDecoration(
                                            //         color: Colors.black.withOpacity(.5),
                                            //         borderRadius: BorderRadius.all(
                                            //           Radius.circular(12.sp),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if(controller.challengeDetails.value.challengeActivationType == 'CODE')
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.0.sp),
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
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    iconKey,
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0.sp),
                                                      child: iconStar,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  if (controller.challengeDetails.value.challengeActivationType == 'PAYMENT' && controller.challengeDetails.value.entryFee != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0.sp),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: popupBgColor,
                                          borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 18.sp),
                                          child: StyledText(
                                            '참가비 ${formatDecimalPlaces(controller.challengeDetails.value.entryFee!.toDouble(), 0)} TIK',
                                            fontSize: 16,
                                            fontWeight: 500,
                                            lineHeight: 16,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((controller.challengeDetails.value.rewardQuantity != null && controller.challengeDetails.value.rewardQuantity! > 0) ||
                                    (controller.challengeDetails.value.minDistance != null && controller.challengeDetails.value.minDistance! > 0))
                                  Padding(
                                    padding: EdgeInsets.only(top: 38.0.sp, bottom: 15.sp),
                                    child: const StyledText(
                                      '챌린지 달성 기준',
                                      fontWeight: 500,
                                      fontSize: 18,
                                      lineHeight: 20,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                if (controller.challengeDetails.value.minDistance != null && controller.challengeDetails.value.minDistance! > 0)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.sp),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: popupBgColor,
                                        borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 18.sp),
                                        child: StyledText(
                                          '최소 거리 ${controller.challengeDetails.value.minDistance!.toString()} km',
                                          fontSize: 16,
                                          fontWeight: 500,
                                          lineHeight: 16,
                                          letterSpacing: -.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (controller.challengeDetails.value.rewardQuantity != null && controller.challengeDetails.value.rewardQuantity! > 0)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: popupBgColor,
                                      borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 18.sp),
                                      child: StyledText(
                                        '리더보드 ${controller.challengeDetails.value.rewardQuantity!.toString()}등 까지',
                                        fontSize: 16,
                                        fontWeight: 500,
                                        lineHeight: 16,
                                        letterSpacing: -.1,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                    ],
                  ),
                ),
              if (controller.challengeDetails.value.extBtnLabel != null && controller.challengeDetails.value.extBtnLabel != '' && controller.challengeDetails.value.linkUrl != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 38.0.sp, bottom: 15.sp),
                        child: const StyledText(
                          '챌린지 참여 추가 혜택',
                          fontWeight: 500,
                          fontSize: 18,
                          lineHeight: 20,
                          letterSpacing: -.1,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: popupBgColor,
                          border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: skyBlueColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                        ),
                        child: InkWell(
                          onTap: () {
                            controller.moveToExternalBrowser(controller.challengeDetails.value.linkUrl!);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 18.sp),
                            child: Center(
                              child: StyledText(
                                controller.challengeDetails.value.extBtnLabel!,
                                fontSize: 18,
                                fontWeight: 500,
                                lineHeight: 18,
                                letterSpacing: -.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 40.0.sp),
                child: const Divider(
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
                      const StyledText(
                        '이용안내',
                        fontWeight: 500,
                        fontSize: 18,
                        lineHeight: 20,
                        letterSpacing: -.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Html(
                          shrinkWrap: true,
                          data: controller.challengeDetails.value.description!,
                          style: {
                            "*": Style(
                              lineHeight: LineHeight.percent(130),
                            ),
                            'img': Style(
                              margin: Margins(
                                left: Margin(-20.sp),
                                right: Margin(-20.sp),
                              ),
                            ),
                            "p": Style(
                              margin: Margins.zero,
                              color: Colors.white,
                              lineHeight: LineHeight.percent(130),
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
