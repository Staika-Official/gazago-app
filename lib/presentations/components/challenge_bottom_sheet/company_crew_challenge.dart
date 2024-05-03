import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:intl/intl.dart';


// 챌린지 전 - 참가중
Map renderCompanyCrewReadyJoined(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => null,
    child: Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: deepGrayColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.sp),
          ),

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: const StyledText(
            '시작 전',
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
            color: deepGrayColor,
            letterSpacing: -.1,
          ),
        )),
  );

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: lightGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: const[
        TextSpan(
          text: '곧 챌린지가 시작돼요.',
        ),

      ],
    ),
  );

  return {
    'suffix': suffix,
    'content': content
  };
}



// 챌린지 진행 중 - 참가 중
Map renderCompanyCrewInProgressJoined(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => null,
    child: Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(25.sp),
          ),
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: AppColorData.regular().colorBgInteractivePrimaryPressed,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: StyledText(
            '참가 중',
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
            color: AppColorData.regular().colorBgInteractivePrimaryPressed,
            letterSpacing: -.1,
          ),
        )),
  );

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: lightGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: [
        const TextSpan(
          text: '챌린지 기간까지 화이팅!',
        ),

      ],
    ),
  );

  return {
    'suffix': suffix,
    'content': content
  };
}

// 챌린지 종료
Map renderCompanyCrewEnded(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => null,
    child: Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: deepGrayColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.sp),
          ),

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

  Widget content =  RichText(
    text: TextSpan(
      style: TextStyle(
        color: AppColorData.regular().colorTextSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 22.sp / 16,
      ),
      children: const [
        TextSpan(
          text: '챌린지가 끝났어요.\n',
        ),
        TextSpan(
          text: '다음 챌린지에 도전해 보세요!',
        ),
      ],
    ),
  );

  return {
    'suffix': suffix,
    'content': content
  };
}