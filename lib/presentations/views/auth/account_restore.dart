import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class AccountRestore extends StatelessWidget {
  const AccountRestore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return DefaultContainer(
      isPrevButtonHide: true,
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
                          padding: EdgeInsets.only(bottom: 28.0.sp),
                          child: iconExclamationMark,
                        ),
                        const StyledText(
                          '기존 회원 정보로 계정이 복구 됩니다.',
                          fontSize: 22,
                          fontWeight: 500,
                          lineHeight: 22,
                          letterSpacing: .1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0.sp),
                          child: const StyledText(
                            '탈퇴 후 14일 내 로그인 시\n기존 회원 계정으로 복구 됩니다.\n복구 하시겠습니까?',
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 22,
                            letterSpacing: .1,
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
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: popupBgColor,
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
                          onTap: () => loginController.handleTerminatedCancel(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0.sp),
                            child: const Center(
                                child: StyledText(
                              '아니요',
                              fontSize: 18,
                              lineHeight: 18,
                              fontWeight: 500,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                        onTap: () => loginController.handleFetchWithdrawCancel(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.0.sp),
                          child: const Center(
                              child: StyledText(
                            '계정 해제 진행',
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
          ],
        ),
      ),
    );
  }
}
