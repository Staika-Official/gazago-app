import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

import 'challenge_bottom_sheet/code_challenge.dart';
import 'challenge_bottom_sheet/item_challenge.dart';

Widget renderParticipateInChallenge() {
  ChallengesDetailController challengesDetailController = Get.find();

  String? userState = challengesDetailController.challengeDetails.value.challengeUserState;
  String? challengeState = challengesDetailController.challengeDetails.value.challengeState;
  String? challengeActivationType = challengesDetailController.challengeDetails.value.challengeActivationType;
  // challengesDetailController.challengeDetails.value.userItem = NewChallengeUserItemModel(id: 0, equipped: false);
  print(challengesDetailController.challengeDetails.value.challengeActivationType);
  print(userState);
  print(challengeState);
  Map widgets = {
    'suffix': Container(),
    'content': Container(),
  };

  if (challengeActivationType == 'CODE') {
    // 참여코드형 챌린지
    if (challengeState == 'READY') {
      // 챌린지 전
      if (userState == 'REGISTER_READY') {
        // 접수 전
        widgets = renderCodeReadyRegisterReady(challengesDetailController);
      } else {
        // 접수 중
        if (userState == 'JOINED') {
          widgets = renderCodeReadyJoined(challengesDetailController);
        } else {
          widgets = renderCodeReadyJoinedElse(challengesDetailController);
        }
      }
    } else if (challengeState == 'IN_PROGRESS') {
      // 챌린지 진행 중
      if (userState == 'JOINED') {
        widgets = renderCodeInProgressJoined(challengesDetailController);
      } else if (userState == 'JOIN_AVAILABLE') {
        widgets = renderCodeInProgressJoinedAvailable(challengesDetailController);
      } else if (userState == 'JOIN_CLOSED') {
        // 참가 마감
        widgets = renderCodeInProgressJoinedClosed(challengesDetailController);
      } else {
        // 챌린지 달성
        widgets = renderCodeInProgressElse(challengesDetailController);
      }
    } else {
      // 챌린지 종료
      if (userState == 'COMPLETE') {
        // 챌린지 달성
        widgets = renderCodeEndedComplete(challengesDetailController);
      } else if (userState == 'INCOMPLETE') {
        // 챌린지 미달성
        widgets = renderCodeEndedInComplete(challengesDetailController);
      } else {
        // 참여하지 않은 챌린지가 종료된 경우
        widgets = renderCodeEndedElse(challengesDetailController);
      }
    }
  }
  if (challengeActivationType == 'ITEM') {
    if (challengeState == 'READY') {
      // 챌린지 전
      if (userState == 'REGISTER_READY') {
        // 접수 전
        widgets = renderItemReadyRegisterReady(challengesDetailController);
      } else {
        // 접수 중
        if (challengesDetailController.challengeDetails.value.userItem != null) {
          if (challengesDetailController.challengeDetails.value.userItem!.equipped) {
            widgets = renderItemReadyJoinedEquipped(challengesDetailController);
          } else {
            widgets = renderItemReadyJoinedNotEquipped(challengesDetailController);
          }
        } else {
          widgets = renderItemReadyJoinedElse(challengesDetailController);
        }
      }
    } else if (challengeState == 'IN_PROGRESS') {
      // 챌린지 진행 중
      if (userState == 'JOINED') {
        widgets = renderItemInProgressJoined(challengesDetailController);
      } else if (userState == 'JOIN_AVAILABLE') {
        if (challengesDetailController.challengeDetails.value.userItem != null) {
          widgets = renderItemInProgressJoinedAvailableHaveItem(challengesDetailController);
        } else {
          widgets = renderItemInProgressJoinedAvailable(challengesDetailController);
        }
      } else if (userState == 'JOIN_CLOSED') {
        // 참가 마감
        widgets = renderItemInProgressJoinedClosed(challengesDetailController);
      } else {
        // 챌린지 달성
        widgets = renderItemInProgressElse(challengesDetailController);
      }
    } else {
      // 챌린지 종료
      if (userState == 'COMPLETE') {
        // 챌린지 달성
        widgets = renderItemEndedComplete(challengesDetailController);
      } else if (userState == 'INCOMPLETE') {
        // 챌린지 미달성
        widgets = renderItemEndedInComplete(challengesDetailController);
      } else {
        // 참여하지 않은 챌린지가 종료된 경우
        widgets = renderItemEndedElse(challengesDetailController);
      }
    }
  }

  if (challengeActivationType == 'CREW') {
    if (challengeState == 'CLOSED') {
      // 챌린지 종료
      widgets = renderItemEndedElse(challengesDetailController);
    }
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
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0.sp, vertical: (userState == 'COMPLETE' || userState == 'INCOMPLETE') ? 5.sp : 20.sp),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: widgets['content'],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0.sp),
                child: widgets['suffix'],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: subBg01Color,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0.sp, bottom: Platform.isAndroid ? 10.0.sp : 24.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                challengeState != 'CLOSED'
                    ? ShaderMask(
                        blendMode: BlendMode.modulate,
                        shaderCallback: (size) => LinearGradient(
                          colors: [skyBlueColor, skyBlueColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(
                          Rect.fromLTWH(0, 0, size.width, 16),
                        ),
                        child: const StyledText(
                          '챌린지 기간',
                          fontSize: 14,
                          lineHeight: 20,
                          fontWeight: 600,
                        ),
                      )
                    : StyledText(
                        '챌린지 기간',
                        fontSize: 14,
                        lineHeight: 20,
                        fontWeight: 600,
                        color: deepGrayColor,
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.sp),
                  child: challengeState != 'CLOSED'
                      ? ShaderMask(
                          blendMode: BlendMode.modulate,
                          shaderCallback: (size) => LinearGradient(
                            colors: [skyBlueColor, skyBlueColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(
                            Rect.fromLTWH(0, 0, size.width, 16),
                          ),
                          child: Text(
                            '${formatDateUntilTime(challengesDetailController.challengeDetails.value.fromDate)} - ${formatDateUntilTime(challengesDetailController.challengeDetails.value.toDate)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              height: (20 / 14).sp,
                            ),
                          ),
                        )
                      : Text(
                          '${formatDateUntilTime(challengesDetailController.challengeDetails.value.fromDate)} - ${formatDateUntilTime(challengesDetailController.challengeDetails.value.toDate)}',
                          style: TextStyle(
                            color: deepGrayColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            height: (20 / 14).sp,
                          ),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
