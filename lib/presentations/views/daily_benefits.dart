import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class DailyBenefits extends StatelessWidget {
  const DailyBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: '일일혜택',
      child: Column(
        children: [
          const StyledText(
            '2023. 12. 13 금요일',
            fontSize: 16,
            lineHeight: 16,
            fontWeight: 500,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 26, bottom: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText(
                  '800',
                  fontFamily: 'Montserrat',
                  fontSize: 50,
                  lineHeight: 50,
                  fontWeight: 600,
                ),
                StyledText(
                  'm',
                  fontFamily: 'Montserrat',
                  fontSize: 50,
                  lineHeight: 50,
                  fontWeight: 500,
                ),
              ],
            ),
          ),
          StyledText(
            '현재 거리',
            fontSize: 16,
            lineHeight: 16,
            fontWeight: 500,
            color: lightGrayColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: SizedBox(
              width: 280,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 13,
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 100,
                      height: 13,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          transform: const GradientRotation(2.3911),
                          colors: [
                            skyBlueColor,
                            const Color(0xff0EF3D8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 36),
                child: StyledText(
                  '매일 걷기와 광고를 보고 혜택을 받아요',
                  fontSize: 20,
                  lineHeight: 18,
                  fontWeight: 500,
                  color: Color(0xffF9F9F9),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 18,
              crossAxisSpacing: 10,
              childAspectRatio: 110 / 150,
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: [
                DailyBenefitItem(adAvailable: false, hasBeenRewarded: true, notAvailable: false),
                DailyBenefitItem(adAvailable: true, hasBeenRewarded: false, notAvailable: false),
                DailyBenefitItem(adAvailable: true, hasBeenRewarded: false, notAvailable: true),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DailyBenefitItem extends StatelessWidget {
  bool adAvailable = false;
  bool hasBeenRewarded = false;
  bool notAvailable = false;

  DailyBenefitItem({
    super.key,
    required this.adAvailable,
    required this.hasBeenRewarded,
    required this.notAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: subBg02Color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black,
            offset: Offset(1, 2),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (adAvailable)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 22,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: const GradientRotation(2.3911),
                    colors: [
                      skyBlueColor,
                      const Color(0xff0EF3D8),
                    ],
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/images/ico_ad.svg'),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 23, left: 15, right: 15, bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/images/ico_daily_benefit_locked.svg'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StyledText(
                        '100',
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        lineHeight: 18,
                        fontWeight: 600,
                      ),
                      StyledText(
                        'm',
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        lineHeight: 18,
                        fontWeight: 500,
                      ),
                    ],
                  ),
                ),
                Material(
                  clipBehavior: Clip.none,
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: hasBeenRewarded || notAvailable ? subBg01Color : skyBlueColor,
                        border: Border.all(
                          color: hasBeenRewarded || notAvailable ? deepGrayColor : Colors.black,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: hasBeenRewarded || notAvailable ? null : () => null,
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: StyledText(
                              '50 Tik 받기',
                              fontSize: 10,
                              lineHeight: 10,
                              fontWeight: 600,
                              letterSpacing: -0.03,
                              color: notAvailable
                                  ? deepGrayColor
                                  : hasBeenRewarded
                                      ? Color(0xFF0EE6F3)
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
