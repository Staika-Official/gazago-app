import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class WithdrawConfirm extends StatelessWidget {
  const WithdrawConfirm({super.key});

  List<Widget> renderCheckList(WithdrawConfirmController controller) {
    return controller.withdrawCheckList
        .map(
          (checkItem) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.sp),
            child: InkWell(
              onTap: () => controller.toggleCheckList(checkItem),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 7.0.sp),
                    child: Icon(
                      Icons.check,
                      color: checkItem.isChecked ? skyBlueColor : deepGrayColor,
                      size: 15.sp,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.sp),
                      child: StyledText(
                        checkItem.title!,
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 24,
                        color: lightGrayColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WithdrawConfirmController controller = Get.put(WithdrawConfirmController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  'withdrawal_confirmation_1'.tr(),
                  fontSize: 22,
                  fontWeight: 700,
                  lineHeight: 22,
                ),
                StyledText(
                  'withdrawal_confirmation_question'.tr(),
                  fontSize: 22,
                  fontWeight: 700,
                  lineHeight: 32,
                  fontFamily: 'Montserrat',
                )
              ],
            ),
            Divider(
              height: 40.sp,
              color: popupBgColor,
              thickness: 1,
            ),
            Obx(
              () => Column(
                children: [
                  InkWell(
                    onTap: () => controller.toggleAllTerms(),
                    child: Row(
                      children: [
                        controller.allAgreed.value
                            ? Icon(
                                Icons.check_circle,
                                color: skyBlueColor,
                                size: 24.sp,
                              )
                            : Icon(
                                Icons.check_circle_rounded,
                                color: popupBgColor,
                                size: 24.sp,
                              ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.sp),
                          child: StyledText(
                            'withdrawal_confirmation_2'.tr(),
                            color: Colors.white,
                            fontWeight: 500,
                            fontSize: 16,
                            lineHeight: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 5.0.sp),
                    child: Column(
                      children: [
                        ...renderCheckList(controller),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Obx(() {
              return Column(
                children: [
                  if (controller.allAgreed.value)
                    Container(
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
                        onTap: () => controller.showWithdrawConfirmPopup(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                          child: Center(
                              child: StyledText(
                            'next_action'.tr(),
                            fontSize: 18,
                            lineHeight: 18,
                            fontWeight: 500,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
