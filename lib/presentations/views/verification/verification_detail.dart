import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/verification_detail_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';

class VerificationDetail extends StatelessWidget {
  const VerificationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    VerificationDetailController controller = Get.put(VerificationDetailController());

    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).requestFocus(FocusNode()),
      child: DefaultContainer(
        backgroundColor: subBg01Color,
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.0.sp),
                child: const StyledText(
                  '본인인증에 필요한\n정보를 입력해주세요.',
                  fontSize: 24,
                  lineHeight: 32,
                  fontWeight: 700,
                ),
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(top: 36.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StyledText(
                        '생년월일',
                        fontSize: 16,
                        fontWeight: 500,
                        color: lightGrayColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.sp),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1,
                          ),
                          onChanged: (dob) => controller.updateBirthday(dob),
                          controller: controller.textEditingController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: popupBgColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: popupBgColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "00000000",
                            hintStyle: TextStyle(
                              color: deepGrayColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              height: 1,
                              letterSpacing: -0.5,
                            ),
                            counterText: "",
                          ),
                          maxLength: 8,
                          cursorColor: skyBlueColor,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 22.0.sp),
                        child: const StyledText(
                          '성별',
                          fontSize: 16,
                          fontWeight: 500,
                          lineHeight: 20,
                          color: lightGrayColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MaterialButton(
                                height: 55.sp,
                                elevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                color: controller.userGender.value == Gender.male ? skyBlueColor : Colors.transparent,
                                disabledColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  side: controller.userGender.value == Gender.male
                                      ? BorderSide.none
                                      : const BorderSide(
                                          color: popupBgColor,
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                ),
                                onPressed: () => controller.updateGender(Gender.male),
                                child: Text(
                                  '남성',
                                  style: TextStyle(
                                    color: controller.userGender.value == Gender.male ? Colors.black : deepGrayColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              indent: 10,
                            ),
                            Expanded(
                              child: MaterialButton(
                                height: 55.sp,
                                elevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                color: controller.userGender.value == Gender.female ? skyBlueColor : Colors.transparent,
                                disabledColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  side: controller.userGender.value == Gender.female
                                      ? BorderSide.none
                                      : const BorderSide(
                                          color: popupBgColor,
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                ),
                                onPressed: () => controller.updateGender(Gender.female),
                                child: Text(
                                  '여성',
                                  style: TextStyle(
                                    color: controller.userGender.value == Gender.female ? Colors.black : deepGrayColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
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
              ),
              const Spacer(),
              Obx(() {
                return Container(
                  height: 55.sp,
                  decoration: BoxDecoration(
                    color: controller.isValidNext.isTrue ? skyBlueColor : popupBgColor,
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
                    onTap: () => controller.isValidNext.isTrue ? controller.nextStep() : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: StyledText(
                        '다음',
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: controller.isValidNext.isTrue ? Colors.black : deepGrayColor,
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
