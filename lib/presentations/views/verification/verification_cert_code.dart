import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/verification_cert_code_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class VerificationCertCode extends StatelessWidget {
  const VerificationCertCode({super.key});

  @override
  Widget build(BuildContext context) {
    VerificationCertCodeController controller = Get.put(VerificationCertCodeController());

    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).requestFocus(FocusNode()),
      child: DefaultContainer(
        backgroundColor: subBg01Color,
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StyledText(
                '문자로 전달된',
                fontSize: 22,
                fontWeight: 700,
                lineHeight: 32,
                fontFamily: 'Montserrat',
              ),
              const Row(
                children: [
                  StyledText(
                    '인증 코드 6자리',
                    fontSize: 22,
                    fontWeight: 700,
                    lineHeight: 32,
                    fontFamily: 'Montserrat',
                    color: skyBlueColor,
                  ),
                  StyledText(
                    '를 입력해주세요.',
                    fontSize: 22,
                    fontWeight: 700,
                    lineHeight: 32,
                    fontFamily: 'Montserrat',
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 36.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: const StyledText(
                          '인증코드',
                          color: lightGrayColor,
                          fontSize: 16,
                          fontWeight: 500,
                        ),
                      ),
                      Obx(() {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: popupBgColor,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: controller.focusNode,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '인증 코드 입력',
                                    hintStyle: TextStyle(
                                      color: deepGrayColor,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 0,
                                    ),
                                    counterText: "",
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                  ),
                                  maxLength: 6,
                                  cursorColor: skyBlueColor,
                                  onChanged: (code) => controller.updateCertCode(code),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: 45,
                                child: StyledText(
                                  controller.countdownString.value,
                                  color: deepGrayColor,
                                  fontWeight: 500,
                                  fontSize: 14,
                                  letterSpacing: .05,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Obx(() {
                                  bool finished = controller.countdownTime.value.inSeconds == 0;
                                  return SizedBox(
                                    height: 35,
                                    width: 85,
                                    child: MaterialButton(
                                      color: finished && !controller.isNotNext.value ? popupBgColor : Colors.transparent,
                                      elevation: 0,
                                      highlightElevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: popupBgColor,
                                          width: finished && !controller.isNotNext.value ? 0 : 2,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      onPressed: () {
                                        if (finished && !controller.isNotNext.value) {
                                          // showConfirmationSnackbar();
                                          controller.resendIdentityCode();
                                        }
                                      },
                                      child: StyledText(
                                        '재전송',
                                        color: finished && !controller.isNotNext.value ? Colors.white : deepGrayColor,
                                        fontSize: 14,
                                        fontWeight: 500,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      }),
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(top: 12.sp),
                          child: StyledText(
                            controller.errorMsg.value,
                            fontSize: 14,
                            fontWeight: 500,
                            color: speedRedColor,
                            lineHeight: 20,
                            letterSpacing: -.01,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Container(
                  height: 55.sp,
                  decoration: BoxDecoration(
                    color: controller.isFormValid.isTrue && !controller.isNotNext.value ? skyBlueColor : popupBgColor,
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
                    onTap: () => controller.isFormValid.isTrue && !controller.isNotNext.value ? controller.next() : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: StyledText(
                        '확인',
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: controller.isFormValid.isTrue && !controller.isNotNext.value ? Colors.black : deepGrayColor,
                      )),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
