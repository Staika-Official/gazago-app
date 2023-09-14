import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:intl/intl.dart';

// 챌린지 전 - 접수 전
Map renderPayReadyRegisterReady(ChallengesDetailController challengesDetailController) {
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
            '접수 전',
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
        height: 24.sp / 16,
      ),
      children: [
        TextSpan(
          text: '접수 예정일  ${DateFormat('MM.dd HH:mm', 'ko').format(DateTime.parse(challengesDetailController.challengeDetails.value.reservedDate!).toLocal())}',
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 전 - 참가중
Map renderPayReadyJoined(ChallengesDetailController challengesDetailController) {
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
            '챌린지 전',
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
        height: 24.sp / 16,
      ),
      children: [
        const TextSpan(
          text: '참가비 납부 완료!\n',
        ),
        TextSpan(
          text: '챌린지 시작을 기다려주세요',
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 전 - 접수 중
Map renderPayReadyJoinedElse(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    // onTap: () => challengesDetailController.showMoveToShopItem(),
    onTap: () => challengesDetailController.isDisableButton.value ? null : challengesDetailController.requestJoinChallenge(challengesDetailController.onJoinPayChallenge),
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
          child: const StyledText(
            '참가하기',
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
        height: 24.sp / 16,
      ),
      children: [
        const TextSpan(
          text: '참가비 납부하고\n',
        ),
        TextSpan(
          text: '챌린지 참여하기!',
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 가능
Map renderPayInProgressJoinedAvailable(ChallengesDetailController challengesDetailController) {
  Widget suffix = InkWell(
    // onTap: () => challengesDetailController.showMoveToShopItem(),
    onTap: () => challengesDetailController.isDisableButton.value ? null :challengesDetailController.requestJoinChallenge(challengesDetailController.onJoinPayChallenge),
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
          child: const StyledText(
            '참가하기',
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
        height: 24.sp / 16,
      ),
      children: [
        const TextSpan(
          text: '참가비 납부하고\n',
        ),
        TextSpan(
          text: '챌린지 참여하기!',
          style: TextStyle(color: skyBlueColor),
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 중
Map renderPayInProgressJoined(ChallengesDetailController challengesDetailController) {
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
          child: const StyledText(
            '참가 중',
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
        height: 24.sp / 16,
      ),
      children: [
        const TextSpan(
          text: '참가비 납부가 완료되어\n',
        ),
        TextSpan(
          text: '챌린지 참가중',
          style: TextStyle(color: skyBlueColor),
        ),
        const TextSpan(
          text: '입니다.',
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 참가 마감
Map renderPayInProgressJoinedClosed(ChallengesDetailController challengesDetailController) {
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
            '참가마감',
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
        height: 24.sp / 16,
      ),
      children: [
        TextSpan(
          text: '모집인원 달성!\n',
          style: TextStyle(color: skyBlueColor),
        ),
        const TextSpan(
          text: '다음 챌린지를 기대해주세요.',
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 진행 중 - 챌린지 달성
Map renderPayInProgressElse(ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeSuccess;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 24.sp / 16,
      ),
      children: const [
        TextSpan(
          text: '수고하셨습니다.\n',
        ),
        TextSpan(
          text: '리더보드를 확인해주세요!',
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 종료 - 챌린지 달성
Map renderPayEndedComplete(ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeSuccess;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 24.sp / 16,
      ),
      children: const [
        TextSpan(
          text: '수고하셨습니다.\n',
        ),
        TextSpan(
          text: '리더보드를 확인해주세요!',
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}

// 챌린지 종료 - 챌린지 미달성
Map renderPayEndedInComplete(ChallengesDetailController challengesDetailController) {
  Widget suffix = iconChallengeFailure;

  Widget content = RichText(
    text: TextSpan(
      style: TextStyle(
        color: skyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 24.sp / 16,
      ),
      children: const [
        TextSpan(
          text: '챌린지에 참가해주셔서\n',
        ),
        TextSpan(
          text: '감사합니다!',
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
            '종료',
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
        height: 24.sp / 16,
      ),
      children: const [
        TextSpan(
          text: '챌린지가 종료되었습니다\n',
        ),
        TextSpan(
          text: '다음챌린지를 기대해주세요',
        ),
      ],
    ),
  );

  return {'suffix': suffix, 'content': content};
}
