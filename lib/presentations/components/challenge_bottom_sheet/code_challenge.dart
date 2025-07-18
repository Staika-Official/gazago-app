import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

// 챌린지 전 - 접수 전
Map renderCodeReadyRegisterReady(
    ChallengesDetailController challengesDetailController) {
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
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: StyledText(
            'before_registration'.tr(),
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
            color: deepGrayColor,
            letterSpacing: -.1,
          ),
        )),
  );

  String locale = PlatformDispatcher.instance.locale.languageCode;
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
          text: 'scheduled_date'.tr(args: [
            DateFormat('MM.dd HH:mm', locale).format(DateTime.parse(
                    challengesDetailController
                        .challengeDetails.value.reservedDate!)
                .toLocal())
          ]),
          style: const TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 전 - 참가중
Map renderCodeReadyJoined(
    ChallengesDetailController challengesDetailController) {
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
          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
          child: StyledText(
            'before_challenge'.tr(),
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
          text: 'participation_code_verified'.tr(),
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
Map renderCodeReadyJoinedElse(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => challengesDetailController.isDisableButton.value
        ? null
        : challengesDetailController
            .requestJoinChallenge(participateInChallengeByCodeAlert),
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
          text: 'participate_after_code_verification'.tr(),
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
Map renderCodeInProgressJoined(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
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
            'participating_challenge'.tr(),
            fontWeight: 500,
            fontSize: 18,
            lineHeight: 18,
            color: Colors.black,
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
          text: 'participating_via_code'.tr(),
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

// 챌린지 진행 중 - 참가 가능
Map renderCodeInProgressJoinedAvailable(
    ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    onTap: () => challengesDetailController.isDisableButton.value
        ? null
        : challengesDetailController
            .requestJoinChallenge(participateInChallengeByCodeAlert),
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
          text: 'participate_after_code_verification'.tr(),
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

// 챌린지 진행 중 - 참가 마감
Map renderCodeInProgressJoinedClosed(
    ChallengesDetailController challengesDetailController) {
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
        ),
        TextSpan(
          text: 'awaiting_next_challenge'.tr(),
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 챌린지 달성
Map renderCodeInProgressElse(
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
Map renderCodeEndedComplete(
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
Map renderCodeEndedInComplete(
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
Map renderCodeEndedElse(ChallengesDetailController challengesDetailController) {
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
