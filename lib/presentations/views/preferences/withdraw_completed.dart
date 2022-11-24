import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class WithdrawCompleted extends StatelessWidget {
  const WithdrawCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WithdrawConfirmController controller = Get.put(WithdrawConfirmController());
    return DefaultContainer(
      backgroundColor: const Color(0xFF1D1D26),
      isPrevButtonHide: true,
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
                        const StyledText(
                          '회원 탈퇴 완료',
                          fontSize: 22,
                          fontWeight: 500,
                          lineHeight: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0.sp),
                          child: const StyledText(
                            '그동안 이용해 주셔서 감사합니다.',
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 22,
                            textAlign: TextAlign.center,
                            color: Color(0xFF8A8A8A),
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
              child: Container(
                height: 55.sp,
                decoration: BoxDecoration(
                  color: const Color(0xFF0EE6F3),
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
                  onTap: () => controller.handleWithdrawComplete(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                    child: const Center(
                        child: StyledText(
                      '확인',
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
