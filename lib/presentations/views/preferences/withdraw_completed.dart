import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class WithdrawCompleted extends StatelessWidget {
  const WithdrawCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    WithdrawConfirmController controller = Get.put(WithdrawConfirmController());
    return DefaultContainer(
      backgroundColor: subBg01Color,
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
                        StyledText(
                          'withdrawal_complete'.tr(),
                          fontSize: 22,
                          fontWeight: 500,
                          lineHeight: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0.sp),
                          child: StyledText(
                            'thank_you_message_1'.tr(),
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
                  onTap: () => controller.handleWithdrawComplete(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                    child: Center(
                        child: StyledText(
                      'confirm'.tr(),
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
