import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class FairPlayContent extends StatelessWidget {
  EdgeInsets padding = EdgeInsets.zero;
  FairPlayContent({super.key, this.padding = const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 60)});

  Widget titleWidget(text, [textColor]) {
    return StyledText(
      text,
      fontSize: 16,
      fontWeight: 700,
      lineHeight: 24,
      color: textColor ?? Colors.white,
    );
  }

  Widget subtitleWidget(text) {
    return StyledText(
      text,
      fontSize: 14,
      fontWeight: 700,
      lineHeight: 22,
      color: skyBlueColor,
    );
  }

  Widget contentWidget(text, [subtext, textColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 7),
          child: StyledText(
            '\u22C5',
            fontSize: 14,
            lineHeight: 22,
            fontWeight: 500,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 22 / 14,
              ),
              children: [
                TextSpan(
                  text: '$text',
                ),
                if (subtext != null)
                  TextSpan(
                    text: '\n$subtext',
                    style: TextStyle(
                      color: lightGrayColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 22 / 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            titleWidget('가자고는 운동 & 챌린지 공정성을 위해 경고 & 퇴장 카드를 발급하고 있어요.'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('성실하고 열심히 운동한 회원님들을 보호하기 위해, 경고 & 퇴장 카드 제도를 운영하고 있어요.'),
            ),
            contentWidget('운영진 최종 검토 후 카드를 발급하고 있어요.'),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: titleWidget('다음과 같은 경우에 경고 카드가 발급 될 수 있어요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('운동 반경 또는 경로가 정상적이지 않은 경우', 'ex) 같은 장소에서 반복적이거나, 운동 시작점에서 켜두기만 한 경우'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: titleWidget('다음과 같은 경우에 퇴장 카드가 발급 될 수 있어요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('한 계정을 여러 기기로 로그인 해서 운동하는 경우'),
            ),
            contentWidget('한 사람이 동시에 여러 기기로 운동하는 경우', 'ex) 지속적인 동일한 운동 경로 등등'),
            contentWidget('의도적인 GPS 조작 또는 걸음 수 조작을 위한 도구를 이용한 경우'),
            contentWidget('경고 카드 2회 누적'),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('그 외에 다음과 같은 경우 카드가 발급 될 수 있어요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('다수의 회원들로부터 공정성에 의심 받았는데, 회사가 그 의심이 납득 가능하다고 판단한 경우에 사안에 따라 경고 또는 퇴장 카드 발급'),
            ),
            contentWidget('서비스 운영 방해', 'ex) 허위 사실 유포 또는 확인되지 않은 부분에 대해 다른 사용자에게 혼란을 초래하거나 서비스 운영에 방해가 되는 행위를 하는 경우. 서비스 이용 제한'),
            contentWidget('서비스 오류 & 버그 악용', 'ex) 서비스 오류에 대한 이득으로 생태계에 영향을 주는 경우. 고의성 여부에 따라 경고 또는 퇴장 카드 발급'),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: contentWidget('부정 거래. 정상적이지 않은 계정을 취득 & 양도 매매하는 경우'),
            ),
            contentWidget('개인정보 유출. 다른 사용자의 개인 정보를 동의 없이 유포하는 경우'),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('경고 & 퇴장 카드를 받게 될 경우 다음과 같은 패널티가 주어져요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('경고 카드'),
            ),
            contentWidget('당일 획득한 GO 리셋'),
            contentWidget('30일 이용 제한 - 서비스 운영에 방해되는 경우에만 해당'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('퇴장 카드'),
            ),
            contentWidget('GO 지갑 제한'),
            contentWidget('계정 생성 불가'),
            contentWidget('영구적인 운동 & 챌린지 제한'),
            contentWidget('보상으로 획득한 TIK, STIK, 기프티콘 등 회수 및 소멸'),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 10),
              child: titleWidget(
                '유의사항',
                lightGrayColor,
              ),
            ),
            contentWidget('위 내용은 운영 상황에 따라 사전 고지 없이 변경될 수 있습니다.', null, lightGrayColor),
            contentWidget('카드 발급시 관련된 모든 계정에 동일하게 발급됩니다.', null, lightGrayColor),
            contentWidget('경고 및 퇴장 카드 이력은 삭제되지 않습니다.', null, lightGrayColor),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: StyledText(
                '공정하고 클린한 가자고 활동을 위해 여러분들의 많은 협조 부탁 드립니다.',
                fontWeight: 500,
                fontSize: 14,
                lineHeight: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
