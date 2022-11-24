import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class WithdrawConfirm extends StatelessWidget {
  const WithdrawConfirm({Key? key}) : super(key: key);

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
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                StyledText(
                  '정말로 gazaGO 서비스를',
                  fontSize: 22,
                  fontWeight: 700,
                  lineHeight: 22,
                ),
                StyledText(
                  '탈퇴 하시겠습니까?',
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
                          child: const StyledText(
                            '탈퇴 전 꼭 확인해 주세요.',
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
                    padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 5.0.sp),
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
                          child: const Center(
                              child: StyledText(
                            '다음',
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
