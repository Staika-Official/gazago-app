import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

Widget renderParticipateInChallenge(ChallengeStatusType statusType) {
  Widget content;
  Widget suffixWidget;
  switch (statusType) {
    case ChallengeStatusType.participating:
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
    case ChallengeStatusType.enter:
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
              text: '2.1 (일) - 3.1 (일)\n약 ',
            ),
            TextSpan(
              text: '10',
              style: TextStyle(color: skyBlueColor),
            ),
            TextSpan(
              text: '일 동안',
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => moveBuyChallengeItemPageAlert(),
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
    case ChallengeStatusType.soldout:
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
    case ChallengeStatusType.success:
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
    case ChallengeStatusType.failure:
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
    case ChallengeStatusType.ended:
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
    case ChallengeStatusType.beforeOpenEnter:
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
              text: '2.1 (일) - 3.1 (일)\n',
            ),
            TextSpan(
              text: 'D-13 오픈예정',
              style: TextStyle(color: skyBlueColor),
            ),
          ],
        ),
      );

      suffixWidget = InkWell(
        onTap: () => null,
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
    case ChallengeStatusType.beforeOpen:
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
              text: '2.1 (일) - 3.1 (일)\n',
            ),
            TextSpan(
              text: 'D-13 오픈예정',
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
