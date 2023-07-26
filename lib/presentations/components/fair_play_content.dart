import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class FairPlayContent extends StatelessWidget {
  EdgeInsets padding = EdgeInsets.zero;
  FairPlayContent({super.key, this.padding = const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 60)});

  Widget titleWidget(text) {
    return StyledText(
      text,
      fontSize: 16,
      fontWeight: 700,
      lineHeight: 24,
    );
  }

  Widget subtitleWidget(text) {
    return StyledText(
      text,
      fontSize: 14,
      fontWeight: 700,
      lineHeight: 22,
      color: const Color(0xFF0EE6F3),
    );
  }

  Widget contentWidget(text, [subtext]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 7),
          child: StyledText(
            '\u22C5',
            fontSize: 14,
            lineHeight: 21,
            fontWeight: 500,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 1.5,
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
                      height: 1.5,
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
            titleWidget('가자고는 운동 & 챌린지 공정성을 위해 경고 & 퇴장카드를 발급하고 있어요.'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('성실하고 열심히 운동한 회원님들을 보호하기 위해, 경고 & 퇴장 카드 제도를 운영하고 있어요. 운영진 최종 검토 후 카드를 발급하고 있어요.'),
            ),
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
            contentWidget('의도적인 GPS 조작 또는 걸음 수 조작을 위한 도구를 이용한 경우, 경고 카드 3회 누적'),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('그 외에 다음과 같은 경우 카드가 발급 될 수 있어요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('다수의 회원들로부터 공정성에 의심 받았는데, 회사가 그 의심이 납득 가능하다고 판단한 경우에 사안에 따라 경고 또는 퇴장 카드 발급'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('경고 & 퇴장 카드를 받게 될 경우 다음과 같은 패널티가 주어져요.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('경고 카드 1회'),
            ),
            contentWidget('당일 획득한 GO 리셋'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('퇴장 카드 1회'),
            ),
            contentWidget('당일 획득한 GO 리셋'),
            contentWidget('보유 TIK 기프티콘 교환 불가'),
            contentWidget('7일간 운동 & 챌린지 제한'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('퇴장 카드 2회'),
            ),
            contentWidget('보상으로 획득한 TIK, STIK, 기프티콘 등 회수 및 소멸'),
            contentWidget('12개월간 운동 & 챌린지 제한'),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('공정하고 클린한 가자고 활동을 위해 여러분들의 많은 협조 부탁 드립니다.'),
            ),
          ],
        ),
      ),
    );
  }
}
