import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class SignupComplete extends StatelessWidget {
  const SignupComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      isLeadingShow: false,
      backgroundColor: subBg01Color,
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 25.0.sp),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: popupBgColor,
                            child: iconSkyBlueCheck,
                          ),
                        ),
                        const StyledText(
                          '회원가입이 완료 되었습니다.',
                          fontSize: 22,
                          fontWeight: 500,
                          lineHeight: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0.sp),
                          child: const StyledText(
                            '이제 gazaGO와 함께\n즐거운 운동을 시작해 보세요.!',
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 22,
                            textAlign: TextAlign.center,
                            color: deepGrayColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 50.sp,
              right: 0,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: const StyledText(
                          '기존에 가입된 회원정보가 있어 계정 연동이 완료되었습니다. 연결된 계정은 ‘설정 > 계정정보 > SNS로그인 에서 확인 가능합니다.',
                          color: lightGrayColor,
                          fontSize: 14,
                          lineHeight: 20,
                          fontWeight: 500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 55.sp,
                decoration: BoxDecoration(
                  color: skyBlueColor,
                  border: Border.all(width: 2.sp, color: Colors.black),
                  borderRadius: BorderRadius.circular(8.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 3.sp),
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () => Get.offAllNamed(Routes.loading),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                    child: const Center(
                        child: StyledText(
                      '시작하기',
                      fontSize: 18,
                      lineHeight: 18,
                      fontWeight: 500,
                      color: Colors.black,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
