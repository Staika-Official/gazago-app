import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget renderParticipateInChallenge(String statusType) {
  ChallengesDetailController challengesDetailController = Get.find();
  Widget content;
  Widget suffixWidget;
  switch (statusType) {
    case 'JOINED':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: lightGrayColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '아이템 장착으로\n',
            ),
            TextSpan(
              text: '챌린지 참가중',
              style: TextStyle(color: skyBlueColor),
            ),
            TextSpan(
              text: '입니다.',
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => null,
        child: Container(
            decoration: BoxDecoration(
              color: skyBlueColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
              child: StyledText(
                '참가 중',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                color: Colors.black,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    case 'JOIN_AVAILABLE':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: lightGrayColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '${challengesDetailController.fromDate} - ${challengesDetailController.toDate}\n약 ',
            ),
            TextSpan(
              text: challengesDetailController.inDays.value.toString(),
              style: TextStyle(color: skyBlueColor),
            ),
            TextSpan(
              text: '일 동안',
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => challengesDetailController.moveToShopItem(),
        child: Container(
            decoration: BoxDecoration(
              color: popupBgColor,
              border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: skyBlueColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
              child: StyledText(
                '참가하기',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    case 'JOIN_CLOSED':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: lightGrayColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '아이템 판매완료',
              style: TextStyle(color: skyBlueColor),
            ),
            TextSpan(
              text: '로\n챌린지 참가가 마감되었습니다.',
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => null,
        child: Container(
            decoration: BoxDecoration(
              color: subBg01Color,
              border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: deepGrayColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
              child: StyledText(
                '참가마감',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                color: deepGrayColor,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    case 'COMPLETE':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: skyBlueColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '수고하셨습니다.\n',
            ),
            TextSpan(
              text: '리더보드를 확인해주세요!',
            ),
          ],
        ),
      );

      suffixWidget = iconChallengeSuccess;
      break;
    case 'INCOMPLETE':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: skyBlueColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '챌린지에 참가해주셔서\n',
            ),
            TextSpan(
              text: '감사합니다!',
            ),
          ],
        ),
      );

      suffixWidget = iconChallengeFailure;
      break;
    case 'CLOSED':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: skyBlueColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '챌린지가 종료되었습니다\n',
            ),
            TextSpan(
              text: '다음챌린지를 기대해주세요',
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => null,
        child: Container(
            decoration: BoxDecoration(
              color: subBg01Color,
              border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: deepGrayColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 40.sp),
              child: StyledText(
                '종료',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                color: deepGrayColor,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    case 'REGISTER_AVAILABLE':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: lightGrayColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '${challengesDetailController.fromDate} - ${challengesDetailController.toDate}\n',
            ),
            TextSpan(
              text: '오픈일 : ${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(challengesDetailController.challengeDetails.value.fromDate!))}',
              style: TextStyle(color: skyBlueColor),
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => challengesDetailController.moveToShopItem(),
        child: Container(
            decoration: BoxDecoration(
              color: popupBgColor,
              border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: skyBlueColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
              child: StyledText(
                '참가하기',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    case 'REGISTER_READY':
      content = RichText(
        text: TextSpan(
          style: TextStyle(
            color: lightGrayColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 24.sp / 16,
          ),
          children: [
            TextSpan(
              text: '${challengesDetailController.fromDate} - ${challengesDetailController.toDate}\n',
            ),
            TextSpan(
              text: '오픈일 : ${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(challengesDetailController.challengeDetails.value.fromDate!))}',
              style: TextStyle(color: skyBlueColor),
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => null,
        child: Container(
            decoration: BoxDecoration(
              color: subBg01Color,
              border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: deepGrayColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25.sp),
              ),
              boxShadow: [
                BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
              child: StyledText(
                '오픈예정',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 18,
                color: deepGrayColor,
                letterSpacing: -.1,
              ),
            )),
      );
      break;
    default:
      content = Text('');
      suffixWidget = Container();
  }

  return Container(
    decoration: BoxDecoration(
      color: popupBgColor,
      border: Border.all(
        width: 2,
        color: Colors.black,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.sp),
        topRight: Radius.circular(25.sp),
      ),
    ),
    width: double.infinity,
    // height: 50,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0.sp, vertical: (statusType == ChallengeStatusType.success || statusType == ChallengeStatusType.failure) ? 5.sp : 20.sp),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: content,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0.sp),
            child: suffixWidget,
          ),
        ],
      ),
    ),
  );
}
