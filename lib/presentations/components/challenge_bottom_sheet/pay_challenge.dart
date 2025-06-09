import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

// 챌린지 전 - 접수 전
Map renderPayReadyRegisterReady(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => null,
    child: Container(
        decoration: BoxDecoration(
          color: AppColorData.regular().colorBgTertiary,
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: AppColorData.regular().colorBgInteractivePrimaryDisabled,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.sp),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: StyledText(
            'before_registration'.tr(),
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
            color: AppColorData.regular().colorBgInteractivePrimaryDisabled,
            letterSpacing: -.1,
          ),
        )),
  );

  Widget content = Text(
    'participation_fee_payment_scheduled_date'.tr(
      args: [
        DateFormat('MM.dd HH:mm', 'ko').format(DateTime.parse(
                challengesDetailController.challengeDetails.value.reservedDate!)
            .toLocal())
      ],
    ),
    style: AppTextStyleData.regular().koBodySemiboldLg.copyWith(
          color: AppColorData.regular().colorTextBrand,
        ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 전 - 참가중
Map renderPayReadyJoined(
    ChallengesDetailController challengesDetailController) {
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
            'participating_challenge'.tr(),
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
        TextSpan(
          text: 'participation_fee_payment_complete'.tr(),
        ),
        TextSpan(
          text: 'awaiting_challenge_start'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 전 - 접수 중
Map renderPayReadyJoinedElse(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    // onTap: () => challengesDetailController.showMoveToShopItem(),
    onTap: () => challengesDetailController.isDisableButton.value
        ? null
        : challengesDetailController.requestJoinChallenge(
            challengesDetailController.onJoinPayChallenge),
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
            'participate_in_challenge'.tr(),
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
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
        TextSpan(
          text: 'participate_after_fee_payment'.tr(),
        ),
        TextSpan(
          text: 'join_challenge'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 가능
Map renderPayInProgressJoinedAvailable(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    // onTap: () => challengesDetailController.showMoveToShopItem(),
    onTap: () => challengesDetailController.isDisableButton.value
        ? null
        : challengesDetailController.requestJoinChallenge(
            challengesDetailController.onJoinPayChallenge),
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
            'participate_in_challenge'.tr(),
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
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
        TextSpan(
          text: 'participate_after_fee_payment'.tr(),
        ),
        TextSpan(
          text: 'join_challenge'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 중
Map renderPayInProgressJoined(
    ChallengesDetailController challengesDetailController) {
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
            'participating_challenge'.tr(),
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
        TextSpan(
          text: 'participation_fee_paid'.tr(),
        ),
        TextSpan(
          text: 'challenge_participating'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
        TextSpan(
          text: 'challenge_participation_status'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 마감
Map renderPayInProgressJoinedClosed(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => null,
    child: Container(
        decoration: BoxDecoration(
          color: AppColorData.regular().colorBgTertiary,
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: AppColorData.regular().colorBgInteractivePrimaryDisabled,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.sp),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: StyledText(
            'participation_closed_1'.tr(),
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
      children: [
        TextSpan(
          text: 'participant_limit_reached'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
        TextSpan(
          text: 'awaiting_next_challenge_very_short'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 챌린지 달성
Map renderPayInProgressElse(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeSuccess;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: [
        TextSpan(
          text: 'challenge_completion_message'.tr(),
        ),
        TextSpan(
          text: 'check_leaderboard'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 종료 - 챌린지 달성
Map renderPayEndedComplete(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeSuccess;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: [
        TextSpan(
          text: 'challenge_completion_message'.tr(),
        ),
        TextSpan(
          text: 'check_leaderboard'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 종료 - 챌린지 미달성
Map renderPayEndedInComplete(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeFailure;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: [
        TextSpan(
          text: 'thank_you_for_participation'.tr(),
        ),
        TextSpan(
          text: 'thank_you_message'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 종료 - 참여하지 않음
Map renderPayEndedElse(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
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
            'finished'.tr(),
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
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 20.sp / 16,
      ),
      children: [
        TextSpan(
          text: 'challenge_ended_1'.tr(),
        ),
        TextSpan(
          text: 'awaiting_next_challenge_short'.tr(),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}
