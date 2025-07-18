import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/verification_phone_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

import '../../../constants/enums.dart';
import '../../components/alert_ui_list.dart';

class VerificationPhone extends StatelessWidget {
  const VerificationPhone({super.key});

  @override
  Widget build(BuildContext context) {
    VerificationPhoneController controller =
        Get.put(VerificationPhoneController());

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
                child: StyledText(
                  'enter_verification_info'.tr(),
                  fontSize: 24,
                  lineHeight: 32,
                  fontWeight: 700,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: StyledText(
                          'phone_number'.tr(),
                          fontWeight: 500,
                          fontSize: 16,
                          letterSpacing: .1,
                          color: lightGrayColor,
                        ),
                      ),
                      Container(
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
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => showTelecomList(controller),
                              child: Container(
                                width: 150.sp,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.sp, vertical: 16.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: 70,
                                        ),
                                        child: Obx(() {
                                          return controller
                                                      .mobileCompany.value ==
                                                  null
                                              ? StyledText(
                                                  'carrier'.tr(),
                                                  fontSize: 20,
                                                  lineHeight: 24,
                                                  fontWeight: 500,
                                                  color: deepGrayColor,
                                                )
                                              : StyledText(
                                                  controller.mobileCompany
                                                      .value!.mobileCompanyName,
                                                  fontSize: 20,
                                                  lineHeight: 24,
                                                  fontWeight: 500,
                                                  overflowEllipsis: true,
                                                );
                                        }),
                                      ),
                                    ),
                                    iconSelectArrowDown,
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enter_without_hyphen'.tr(),
                                  hintStyle: TextStyle(
                                    color: deepGrayColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.sp,
                                    letterSpacing: -0.5,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0.sp,
                                    vertical: 18.sp,
                                  ),
                                  counterText: "",
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2.sp,
                                ),
                                cursorColor: skyBlueColor,
                                onChanged: (mobileNumber) =>
                                    controller.updateMobileNumber(mobileNumber),
                                controller: controller.textEditingController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 11,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Container(
                  height: 55.sp,
                  decoration: BoxDecoration(
                    color: controller.isFormValid.isTrue
                        ? skyBlueColor
                        : popupBgColor,
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
                    onTap: () => controller.isFormValid.isTrue
                        ? controller.sendIdentityCode()
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: StyledText(
                        'auth_code_sent'.tr(),
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: controller.isFormValid.isTrue
                            ? Colors.black
                            : deepGrayColor,
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
