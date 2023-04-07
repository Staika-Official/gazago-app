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
import 'package:get/get.dart';

Future<String> showConfirmPasswordDialog(WalletMasterController controller) {
  ConfirmWalletPasswordController controller = Get.put(ConfirmWalletPasswordController());
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
                      text: '안전한 지갑 사용을 위해\n',
                    ),
                    TextSpan(
                      text: '이체 비밀번호',
                      style: TextStyle(color: skyBlueColor),
                    ),
                    TextSpan(
                      text: '를 한번 확인합니다.',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: StyledText(
                        '이체 비밀번호',
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                hintText: '이체 비밀번호를 입력해주세요',
                                hintStyle: TextStyle(
                                  color: deepGrayColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              onChanged: (password) => controller.updatePassword(password),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.passwordFormStatus.value != FormStatus.empty,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: controller.passwordFormStatus.value == FormStatus.insufficient ? iconPasswordInvalid : iconPasswordValid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 10),
                      child: Text(
                        '• 8~16자로 영문, 숫자, 특수문자가 조합되어 있습니다.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffa4a4a4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              child: GazagoButton(
                onTap: () {
                  String? password = controller.nextStep();
                  completer.complete(password);
                },
                buttonText: '확인',
                buttonColor: skyBlueColor,
                // textColor: Colors.white,
                // buttonColor: popupBgColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return completer.future;
}
