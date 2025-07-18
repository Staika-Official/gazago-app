import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/confirm_wallet_password_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

Future<String> showConfirmPasswordDialog(WalletMasterController controller) {
  ConfirmWalletPasswordController controller =
      Get.put(ConfirmWalletPasswordController());
  controller.passwordFormStatus.value = FormStatus.empty;
  Completer<String> completer = Completer();

  Get.dialog(
    barrierDismissible: false,
    useSafeArea: false,
    Dialog(
      insetPadding: EdgeInsets.zero,
      child: DefaultContainer(
        backgroundColor: subBg01Color,
        resizeToAvoidBottomInset: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22.sp,
                    height: 32.sp / 22,
                  ),
                  children: [
                    TextSpan(
                      text: 'for_secure_wallet'.tr(),
                    ),
                    TextSpan(
                      text: 'transfer_password'.tr(),
                      style: TextStyle(color: skyBlueColor),
                    ),
                    TextSpan(
                      text: 'verify_transfer_password'.tr(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 36, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: StyledText(
                        'transfer_password'.tr(),
                        color: lightGrayColor,
                        fontSize: 16,
                        lineHeight: 12,
                        letterSpacing: -0.5,
                        fontWeight: 500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: popupBgColor,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.white,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'enter_transfer_password'.tr(),
                                hintStyle: const TextStyle(
                                  color: deepGrayColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              focusNode: controller.passwordFocusNode,
                              onChanged: (password) =>
                                  controller.updatePassword(password),
                              onSubmitted: (String text) async =>
                                  await controller.isValidPassword(completer),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.passwordFormStatus.value !=
                                  FormStatus.empty,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: controller.passwordFormStatus.value ==
                                        FormStatus.insufficient
                                    ? iconPasswordInvalid
                                    : iconPasswordValid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.isFocused.value)
                        return Padding(
                          padding: const EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            'password_format'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffa4a4a4),
                            ),
                          ),
                        );
                      else
                        return SizedBox();
                    })
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 36),
              width: double.infinity,
              child: Obx(() {
                return GazagoButton(
                  onTap: () async {
                    await controller.isValidPassword(completer);
                  },
                  buttonText: 'confirm'.tr(),
                  buttonColor: controller.passwordFormStatus.value ==
                          FormStatus.sufficient
                      ? skyBlueColor
                      : deepGrayColor,
                  // textColor: Colors.white,
                  // buttonColor: popupBgColor,
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );

  return completer.future;
}
