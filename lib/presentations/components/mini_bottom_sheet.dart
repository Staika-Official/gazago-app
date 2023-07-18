import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget renderParticipateInChallenge() {
  ChallengesDetailController challengesDetailController = Get.find();

  Widget content;
  Widget suffixWidget;
  String? userState = challengesDetailController.challengeDetails.value.challengeUserState;
  String? challengeState = challengesDetailController.challengeDetails.value.challengeState;
  String? challengeActivationType = challengesDetailController.challengeDetails.value.challengeActivationType;
  // challengesDetailController.challengeDetails.value.userItem = NewChallengeUserItemModel(id: 0, equipped: false);
  print(challengesDetailController.challengeDetails.value.challengeActivationType);
  print(userState);
  print(challengeState);
  if (challengeActivationType == 'CODE') {
    // 참여코드형 챌린지
    if (challengeState == 'READY') {
      // 챌린지 전
      if (userState == 'REGISTER_READY') {
        // 접수 전
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
                text: '접수 예정일  ${DateFormat('MM.dd HH:mm', 'ko').format(DateTime.parse(challengesDetailController.challengeDetails.value.reservedDate!).toLocal())}',
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
                  '접수 전',
                  fontWeight: 500,
                  fontSize: 18,
                  lineHeight: 18,
                  color: deepGrayColor,
                  letterSpacing: -.1,
                ),
              )),
        );
      } else {
        // 접수 중
        if (userState == 'JOINED') {
          content = RichText(
            text: TextSpan(
              style: TextStyle(
                color: lightGrayColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 24.sp / 16,
              ),
              children: [
                const TextSpan(
                  text: '참여코드 인증완료!\n',
                ),
                TextSpan(
                  text: '챌린지 시작을 기다려주세요',
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
                    '챌린지 전',
                    fontWeight: 500,
                    fontSize: 18,
                    lineHeight: 18,
                    color: deepGrayColor,
                    letterSpacing: -.1,
                  ),
                )),
          );
        } else {
          content = RichText(
            text: TextSpan(
              style: TextStyle(
                color: lightGrayColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 24.sp / 16,
              ),
              children: [
                const TextSpan(
                  text: '참여코드 인증하고\n',
                ),
                TextSpan(
                  text: '챌린지 참여하기!',
                  style: TextStyle(color: skyBlueColor),
                ),
              ],
            ),
          );

          suffixWidget = InkWell(
            onTap: () => participateInChallengeByCodeAlert(),
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
        }
      }
    } else if (challengeState == 'IN_PROGRESS') {
      // 챌린지 진행 중
      if (userState == 'JOINED') {
        content = RichText(
          text: TextSpan(
            style: TextStyle(
              color: lightGrayColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 24.sp / 16,
            ),
            children: [
              const TextSpan(
                text: '참여코드 인증으로\n',
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
      } else if (userState == 'JOIN_AVAILABLE') {
        content = RichText(
          text: TextSpan(
            style: TextStyle(
              color: lightGrayColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 24.sp / 16,
            ),
            children: [
              const TextSpan(
                text: '참여코드 인증하고\n',
              ),
              TextSpan(
                text: '챌린지 참여하기!',
                style: TextStyle(color: skyBlueColor),
              ),
            ],
          ),
        );

        suffixWidget = InkWell(
          onTap: () => participateInChallengeByCodeAlert(),
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
      } else if (userState == 'JOIN_CLOSED') {
        // 참가 마감
        content = RichText(
          text: TextSpan(
            style: TextStyle(
              color: lightGrayColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 24.sp / 16,
            ),
            children: [
              const TextSpan(
                text: '모집인원 달성!\n',
              ),
              TextSpan(
                text: '다음 챌린지를 기대해주세요',
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
                  '참가마감',
                  fontWeight: 500,
                  fontSize: 18,
                  lineHeight: 18,
                  color: deepGrayColor,
                  letterSpacing: -.1,
                ),
              )),
        );
      } else {
        // 챌린지 달성
        content = RichText(
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

        suffixWidget = iconChallengeSuccess;
      }
    } else {
      // 챌린지 종료
      if (userState == 'COMPLETE') {
        // 챌린지 달성
        content = RichText(
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

        suffixWidget = iconChallengeSuccess;
      } else if (userState == 'INCOMPLETE') {
        // 챌린지 미달성
        content = RichText(
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

        suffixWidget = iconChallengeFailure;
      } else {
        // 참여하지 않은 챌린지가 종료된 경우
        content = RichText(
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
      }
    }
  } else {
    if (challengeState == 'READY') {
      // 챌린지 전
      if (userState == 'REGISTER_READY') {
        // 접수 전
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
                text: '접수 예정일  ${DateFormat('MM.dd HH:mm', 'ko').format(DateTime.parse(challengesDetailController.challengeDetails.value.reservedDate!).toLocal())}',
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
                  '접수 전',
                  fontWeight: 500,
                  fontSize: 18,
                  lineHeight: 18,
                  color: deepGrayColor,
                  letterSpacing: -.1,
                ),
              )),
        );
      } else {
        // 접수 중
        if (challengesDetailController.challengeDetails.value.userItem != null) {
          if (challengesDetailController.challengeDetails.value.userItem!.equipped) {
            content = RichText(
              text: TextSpan(
                style: TextStyle(
                  color: lightGrayColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  height: 24.sp / 16,
                ),
                children: [
                  const TextSpan(
                    text: '이미 챌린지 아이템을\n',
                  ),
                  TextSpan(
                    text: '장착중',
                    style: TextStyle(color: skyBlueColor),
                  ),
                  const TextSpan(
                    text: '입니다',
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
                      '챌린지 전',
                      fontWeight: 500,
                      fontSize: 18,
                      lineHeight: 18,
                      color: deepGrayColor,
                      letterSpacing: -.1,
                    ),
                  )),
            );
          } else {
            content = RichText(
              text: TextSpan(
                style: TextStyle(
                  color: lightGrayColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  height: 24.sp / 16,
                ),
                children: [
                  const TextSpan(
                    text: '이미 챌린지 아이템을\n',
                  ),
                  TextSpan(
                    text: '보유중',
                    style: TextStyle(color: skyBlueColor),
                  ),
                  const TextSpan(
                    text: '입니다',
                  ),
                ],
              ),
            );

            suffixWidget = InkWell(
              onTap: () => challengeItemEquip(challengesDetailController.challengeDetails.value.userItem!.id),
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
          }
        } else {
          content = RichText(
            text: TextSpan(
              style: TextStyle(
                color: lightGrayColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 24.sp / 16,
              ),
              children: [
                const TextSpan(
                  text: '아이템 구매 후 장착하고\n',
                ),
                TextSpan(
                  text: '챌린지 참여하기!',
                  style: TextStyle(color: skyBlueColor),
                ),
              ],
            ),
          );

          suffixWidget = InkWell(
            onTap: () => challengesDetailController.showMoveToShopItem(),
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
        }
      }
    } else if (challengeState == 'IN_PROGRESS') {
      // 챌린지 진행 중
      if (userState == 'JOINED') {
        content = RichText(
          text: TextSpan(
            style: TextStyle(
              color: lightGrayColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 24.sp / 16,
            ),
            children: [
              const TextSpan(
                text: '아이템 장착으로\n',
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
      } else if (userState == 'JOIN_AVAILABLE') {
        if (challengesDetailController.challengeDetails.value.userItem != null) {
          content = RichText(
            text: TextSpan(
              style: TextStyle(
                color: lightGrayColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 24.sp / 16,
              ),
              children: [
                const TextSpan(
                  text: '이미 챌린지 아이템을\n',
                ),
                TextSpan(
                  text: '보유중',
                  style: TextStyle(color: skyBlueColor),
                ),
                const TextSpan(
                  text: '입니다',
                ),
              ],
            ),
          );

          suffixWidget = InkWell(
            onTap: () => challengeItemEquip(challengesDetailController.challengeDetails.value.userItem!.id),
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
        } else {
          content = RichText(
            text: TextSpan(
              style: TextStyle(
                color: lightGrayColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 24.sp / 16,
              ),
              children: [
                const TextSpan(
                  text: '아이템 구매 후 장착하고\n',
                ),
                TextSpan(
                  text: '챌린지 참여하기!',
                  style: TextStyle(color: skyBlueColor),
                ),
              ],
            ),
          );

          suffixWidget = InkWell(
            onTap: () => challengesDetailController.showMoveToShopItem(),
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
        }
      } else if (userState == 'JOIN_CLOSED') {
        // 참가 마감
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
              const TextSpan(
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
      } else {
        // 챌린지 달성
        content = RichText(
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

        suffixWidget = iconChallengeSuccess;
      }
    } else {
      // 챌린지 종료
      if (userState == 'COMPLETE') {
        // 챌린지 달성
        content = RichText(
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

        suffixWidget = iconChallengeSuccess;
      } else if (userState == 'INCOMPLETE') {
        // 챌린지 미달성
        content = RichText(
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

        suffixWidget = iconChallengeFailure;
      } else {
        // 참여하지 않은 챌린지가 종료된 경우
        content = RichText(
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
      }
    }
  }

  // if (challengeState == 'READY') {
  //   // 챌린지 전
  //   if (userState == 'REGISTER_READY') {
  //     // 접수 전
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: lightGrayColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: [
  //           TextSpan(
  //             text: '접수 예정일  ${DateFormat('MM.dd HH:mm', 'ko').format(DateTime.parse(challengesDetailController.challengeDetails.value.reservedDate!).toLocal())}',
  //             style: TextStyle(color: skyBlueColor),
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = InkWell(
  //       onTap: () => null,
  //       child: Container(
  //           decoration: BoxDecoration(
  //             color: subBg01Color,
  //             border: Border.all(
  //               width: 2,
  //               style: BorderStyle.solid,
  //               color: deepGrayColor,
  //             ),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(25.sp),
  //             ),
  //             boxShadow: [
  //               BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //             child: StyledText(
  //               '접수 전',
  //               fontWeight: 500,
  //               fontSize: 18,
  //               lineHeight: 18,
  //               color: deepGrayColor,
  //               letterSpacing: -.1,
  //             ),
  //           )),
  //     );
  //   } else {
  //     // 접수 중
  //     if (challengesDetailController.challengeDetails.value.userItem != null) {
  //       if (challengesDetailController.challengeDetails.value.userItem!.equipped) {
  //         content = RichText(
  //           text: TextSpan(
  //             style: TextStyle(
  //               color: lightGrayColor,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 16.sp,
  //               height: 24.sp / 16,
  //             ),
  //             children: [
  //               const TextSpan(
  //                 text: '이미 챌린지 아이템을\n',
  //               ),
  //               TextSpan(
  //                 text: '장착중',
  //                 style: TextStyle(color: skyBlueColor),
  //               ),
  //               const TextSpan(
  //                 text: '입니다',
  //               ),
  //             ],
  //           ),
  //         );
  //
  //         suffixWidget = InkWell(
  //           onTap: () => null,
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: subBg01Color,
  //                 border: Border.all(
  //                   width: 2,
  //                   style: BorderStyle.solid,
  //                   color: deepGrayColor,
  //                 ),
  //                 borderRadius: BorderRadius.all(
  //                   Radius.circular(25.sp),
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //                 ],
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //                 child: StyledText(
  //                   '챌린지 전',
  //                   fontWeight: 500,
  //                   fontSize: 18,
  //                   lineHeight: 18,
  //                   color: deepGrayColor,
  //                   letterSpacing: -.1,
  //                 ),
  //               )),
  //         );
  //       } else {
  //         content = RichText(
  //           text: TextSpan(
  //             style: TextStyle(
  //               color: lightGrayColor,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 16.sp,
  //               height: 24.sp / 16,
  //             ),
  //             children: [
  //               const TextSpan(
  //                 text: '이미 챌린지 아이템을\n',
  //               ),
  //               TextSpan(
  //                 text: '보유중',
  //                 style: TextStyle(color: skyBlueColor),
  //               ),
  //               const TextSpan(
  //                 text: '입니다',
  //               ),
  //             ],
  //           ),
  //         );
  //
  //         suffixWidget = InkWell(
  //           onTap: () => challengeItemEquip(challengesDetailController.challengeDetails.value.userItem!.id),
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: popupBgColor,
  //                 border: Border.all(
  //                   width: 2,
  //                   style: BorderStyle.solid,
  //                   color: skyBlueColor,
  //                 ),
  //                 borderRadius: BorderRadius.all(
  //                   Radius.circular(25.sp),
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //                 ],
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //                 child: const StyledText(
  //                   '참가하기',
  //                   fontWeight: 500,
  //                   fontSize: 18,
  //                   lineHeight: 18,
  //                   letterSpacing: -.1,
  //                 ),
  //               )),
  //         );
  //       }
  //     } else {
  //       content = RichText(
  //         text: TextSpan(
  //           style: TextStyle(
  //             color: lightGrayColor,
  //             fontWeight: FontWeight.w500,
  //             fontSize: 16.sp,
  //             height: 24.sp / 16,
  //           ),
  //           children: [
  //             const TextSpan(
  //               text: '아이템 구매 후 장착하고\n',
  //             ),
  //             TextSpan(
  //               text: '챌린지 참여하기!',
  //               style: TextStyle(color: skyBlueColor),
  //             ),
  //           ],
  //         ),
  //       );
  //
  //       suffixWidget = InkWell(
  //         onTap: () => challengesDetailController.showMoveToShopItem(),
  //         child: Container(
  //             decoration: BoxDecoration(
  //               color: popupBgColor,
  //               border: Border.all(
  //                 width: 2,
  //                 style: BorderStyle.solid,
  //                 color: skyBlueColor,
  //               ),
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(25.sp),
  //               ),
  //               boxShadow: [
  //                 BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //               ],
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //               child: const StyledText(
  //                 '참가하기',
  //                 fontWeight: 500,
  //                 fontSize: 18,
  //                 lineHeight: 18,
  //                 letterSpacing: -.1,
  //               ),
  //             )),
  //       );
  //     }
  //   }
  // } else if (challengeState == 'IN_PROGRESS') {
  //   // 챌린지 진행 중
  //   if (userState == 'JOINED') {
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: lightGrayColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: [
  //           const TextSpan(
  //             text: '아이템 장착으로\n',
  //           ),
  //           TextSpan(
  //             text: '챌린지 참가중',
  //             style: TextStyle(color: skyBlueColor),
  //           ),
  //           const TextSpan(
  //             text: '입니다.',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = InkWell(
  //       onTap: () => null,
  //       child: Container(
  //           decoration: BoxDecoration(
  //             color: skyBlueColor,
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(25.sp),
  //             ),
  //             boxShadow: [
  //               BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //             child: const StyledText(
  //               '참가 중',
  //               fontWeight: 500,
  //               fontSize: 18,
  //               lineHeight: 18,
  //               color: Colors.black,
  //               letterSpacing: -.1,
  //             ),
  //           )),
  //     );
  //   } else if (userState == 'JOIN_AVAILABLE') {
  //     if (challengesDetailController.challengeDetails.value.userItem != null) {
  //       content = RichText(
  //         text: TextSpan(
  //           style: TextStyle(
  //             color: lightGrayColor,
  //             fontWeight: FontWeight.w500,
  //             fontSize: 16.sp,
  //             height: 24.sp / 16,
  //           ),
  //           children: [
  //             const TextSpan(
  //               text: '이미 챌린지 아이템을\n',
  //             ),
  //             TextSpan(
  //               text: '보유중',
  //               style: TextStyle(color: skyBlueColor),
  //             ),
  //             const TextSpan(
  //               text: '입니다',
  //             ),
  //           ],
  //         ),
  //       );
  //
  //       suffixWidget = InkWell(
  //         onTap: () => challengeItemEquip(challengesDetailController.challengeDetails.value.userItem!.id),
  //         child: Container(
  //             decoration: BoxDecoration(
  //               color: popupBgColor,
  //               border: Border.all(
  //                 width: 2,
  //                 style: BorderStyle.solid,
  //                 color: skyBlueColor,
  //               ),
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(25.sp),
  //               ),
  //               boxShadow: [
  //                 BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //               ],
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //               child: const StyledText(
  //                 '참가하기',
  //                 fontWeight: 500,
  //                 fontSize: 18,
  //                 lineHeight: 18,
  //                 letterSpacing: -.1,
  //               ),
  //             )),
  //       );
  //     } else {
  //       content = RichText(
  //         text: TextSpan(
  //           style: TextStyle(
  //             color: lightGrayColor,
  //             fontWeight: FontWeight.w500,
  //             fontSize: 16.sp,
  //             height: 24.sp / 16,
  //           ),
  //           children: [
  //             const TextSpan(
  //               text: '아이템 구매 후 장착하고\n',
  //             ),
  //             TextSpan(
  //               text: '챌린지 참여하기!',
  //               style: TextStyle(color: skyBlueColor),
  //             ),
  //           ],
  //         ),
  //       );
  //
  //       suffixWidget = InkWell(
  //         onTap: () => challengesDetailController.showMoveToShopItem(),
  //         child: Container(
  //             decoration: BoxDecoration(
  //               color: popupBgColor,
  //               border: Border.all(
  //                 width: 2,
  //                 style: BorderStyle.solid,
  //                 color: skyBlueColor,
  //               ),
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(25.sp),
  //               ),
  //               boxShadow: [
  //                 BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //               ],
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //               child: const StyledText(
  //                 '참가하기',
  //                 fontWeight: 500,
  //                 fontSize: 18,
  //                 lineHeight: 18,
  //                 letterSpacing: -.1,
  //               ),
  //             )),
  //       );
  //     }
  //   } else if (userState == 'JOIN_CLOSED') {
  //     // 참가 마감
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: lightGrayColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: [
  //           TextSpan(
  //             text: '아이템 판매완료',
  //             style: TextStyle(color: skyBlueColor),
  //           ),
  //           const TextSpan(
  //             text: '로\n챌린지 참가가 마감되었습니다.',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = InkWell(
  //       onTap: () => null,
  //       child: Container(
  //           decoration: BoxDecoration(
  //             color: subBg01Color,
  //             border: Border.all(
  //               width: 2,
  //               style: BorderStyle.solid,
  //               color: deepGrayColor,
  //             ),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(25.sp),
  //             ),
  //             boxShadow: [
  //               BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
  //             child: StyledText(
  //               '참가마감',
  //               fontWeight: 500,
  //               fontSize: 18,
  //               lineHeight: 18,
  //               color: deepGrayColor,
  //               letterSpacing: -.1,
  //             ),
  //           )),
  //     );
  //   } else {
  //     // 챌린지 달성
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: skyBlueColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: const [
  //           TextSpan(
  //             text: '수고하셨습니다.\n',
  //           ),
  //           TextSpan(
  //             text: '리더보드를 확인해주세요!',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = iconChallengeSuccess;
  //   }
  // } else {
  //   // 챌린지 종료
  //   if (userState == 'COMPLETE') {
  //     // 챌린지 달성
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: skyBlueColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: const [
  //           TextSpan(
  //             text: '수고하셨습니다.\n',
  //           ),
  //           TextSpan(
  //             text: '리더보드를 확인해주세요!',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = iconChallengeSuccess;
  //   } else if (userState == 'INCOMPLETE') {
  //     // 챌린지 미달성
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: skyBlueColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: const [
  //           TextSpan(
  //             text: '챌린지에 참가해주셔서\n',
  //           ),
  //           TextSpan(
  //             text: '감사합니다!',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = iconChallengeFailure;
  //   } else {
  //     // 참여하지 않은 챌린지가 종료된 경우
  //     content = RichText(
  //       text: TextSpan(
  //         style: TextStyle(
  //           color: skyBlueColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.sp,
  //           height: 24.sp / 16,
  //         ),
  //         children: const [
  //           TextSpan(
  //             text: '챌린지가 종료되었습니다\n',
  //           ),
  //           TextSpan(
  //             text: '다음챌린지를 기대해주세요',
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     suffixWidget = InkWell(
  //       onTap: () => null,
  //       child: Container(
  //           decoration: BoxDecoration(
  //             color: subBg01Color,
  //             border: Border.all(
  //               width: 2,
  //               style: BorderStyle.solid,
  //               color: deepGrayColor,
  //             ),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(25.sp),
  //             ),
  //             boxShadow: [
  //               BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 40.sp),
  //             child: StyledText(
  //               '종료',
  //               fontWeight: 500,
  //               fontSize: 18,
  //               lineHeight: 18,
  //               color: deepGrayColor,
  //               letterSpacing: -.1,
  //             ),
  //           )),
  //     );
  //   }
  // }
  // switch (statusType) {
  //   case 'JOINED':
  //     break;
  //   case 'JOIN_AVAILABLE':
  //     break;
  //   case 'JOIN_CLOSED':
  //     break;
  //   case 'COMPLETE':
  //     break;
  //   case 'INCOMPLETE':
  //     break;
  //   case 'CLOSED':
  //     break;
  //   case 'REGISTER_AVAILABLE':
  //
  //     break;
  //   case 'REGISTER_READY':
  //
  //     break;
  //   default:
  //     content = Text('');
  //     suffixWidget = Container();
  // }

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
                child: content,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0.sp),
                child: suffixWidget,
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
                          colors: [const Color(0XFF0EE6F3), skyBlueColor],
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
                            colors: [const Color(0XFF0EE6F3), skyBlueColor],
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
