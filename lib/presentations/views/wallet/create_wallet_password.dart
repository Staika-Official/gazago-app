import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/create_wallet_password_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class CreateWalletPassword extends StatelessWidget {
  const CreateWalletPassword({super.key});

  Widget validatePassword(FormStatus status) {
    return Visibility(
      visible: status != FormStatus.empty,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: status == FormStatus.insufficient
            ? iconPasswordInvalid
            : iconPasswordValid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CreateWalletPasswordController controller =
        Get.put(CreateWalletPasswordController());
    double appBarHeight = AppBar().preferredSize.height;
    return LayoutBuilder(builder: (context, constraints) {
      return DefaultContainer(
        backgroundColor: subBg01Color,
        resizeToAvoidBottomInset: true,
        onBackButtonTap: () {
          Get.find<WalletMasterController>().tabController.animateTo(0);
          Get.back();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - appBarHeight - 25,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                            text: 'register_password'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    hintText: 'enter_transfer_password'.tr(),
                                    hintStyle: const TextStyle(
                                      color: deepGrayColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (password) =>
                                      controller.updatePassword(password),
                                ),
                              ),
                              Obx(() => validatePassword(
                                  controller.passwordFormStatus.value)),
                            ],
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
                                  // key: const Key(TestNameKey.pwReInput),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15.sp),
                                    hintText: 'verify_transfer_pin'.tr(),
                                    hintStyle: const TextStyle(
                                      color: deepGrayColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.go,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (password) => controller
                                      .updateConfirmPassword(password),
                                  onSubmitted: (password) {
                                    if (controller.confirmPasswordFormStatus
                                                .value ==
                                            FormStatus.sufficient &&
                                        controller.confirmTextStatus.value ==
                                            FormStatus.sufficient) {
                                      controller.nextStep();
                                    }
                                  },
                                ),
                              ),
                              Obx(() => validatePassword(
                                  controller.confirmPasswordFormStatus.value)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            'password_combination'.tr(),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0XFF292A31),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0.sp, horizontal: 12.sp),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0.sp),
                                  child: Row(
                                    children: [
                                      iconExcludeRed,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: StyledText(
                                          'verify_before_registration'.tr(),
                                          color: const Color(0XFFEB4C4C),
                                          fontSize: 16,
                                          lineHeight: 16,
                                          fontWeight: 600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.0.sp),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const StyledText(
                                            '• ',
                                            fontWeight: 500,
                                            fontSize: 16,
                                            lineHeight: 22,
                                            letterSpacing: -.1,
                                            color: lightGrayColor,
                                          ),
                                          Flexible(
                                            child: StyledText(
                                              'staika_wallet_decentralized'
                                                  .tr(),
                                              fontWeight: 500,
                                              fontSize: 14,
                                              lineHeight: 22,
                                              color: lightGrayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            '• ',
                                            fontWeight: 500,
                                            fontSize: 16,
                                            lineHeight: 22,
                                            letterSpacing: -.1,
                                            color: lightGrayColor,
                                          ),
                                          Flexible(
                                            child: StyledText(
                                              'password_not_stored'.tr(),
                                              fontWeight: 500,
                                              fontSize: 14,
                                              lineHeight: 22,
                                              letterSpacing: -.1,
                                              color: lightGrayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            '• ',
                                            fontWeight: 500,
                                            fontSize: 16,
                                            lineHeight: 22,
                                            letterSpacing: -.1,
                                            color: lightGrayColor,
                                          ),
                                          Flexible(
                                            child: StyledText(
                                              'password_loss_irreversible'.tr(),
                                              fontWeight: 500,
                                              fontSize: 14,
                                              lineHeight: 22,
                                              letterSpacing: -.1,
                                              color: lightGrayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            '• ',
                                            fontWeight: 500,
                                            fontSize: 16,
                                            lineHeight: 22,
                                            letterSpacing: -.1,
                                            color: lightGrayColor,
                                          ),
                                          Flexible(
                                            child: StyledText(
                                              'store_password_safely'.tr(),
                                              fontWeight: 500,
                                              fontSize: 14,
                                              lineHeight: 22,
                                              letterSpacing: -.1,
                                              color: lightGrayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: Container(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15),
                                      hintText: 'confirmed'.tr(),
                                      hintStyle: const TextStyle(
                                        color: deepGrayColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (text) =>
                                        controller.updateConfirmText(text),
                                  ),
                                ),
                                Obx(() => validatePassword(
                                    controller.confirmTextStatus.value)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.sp, left: 15.0.sp),
                          child: StyledText(
                            'confirm_understanding'.tr(),
                            fontSize: 12,
                            fontWeight: 500,
                            color: deepGrayColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          width: double.infinity,
                          child: GazagoButton(
                            onTap: () {
                              // print('click');
                              if (controller.confirmPasswordFormStatus.value ==
                                      FormStatus.sufficient &&
                                  controller.confirmTextStatus.value ==
                                      FormStatus.sufficient) {
                                controller.nextStep();
                              }
                            },
                            buttonText: 'confirm'.tr(),
                            buttonColor:
                                (controller.confirmPasswordFormStatus.value ==
                                            FormStatus.sufficient &&
                                        controller.confirmTextStatus.value ==
                                            FormStatus.sufficient)
                                    ? skyBlueColor
                                    : popupBgColor,
                            textColor:
                                (controller.confirmPasswordFormStatus.value ==
                                            FormStatus.sufficient &&
                                        controller.confirmTextStatus.value ==
                                            FormStatus.sufficient)
                                    ? Colors.black
                                    : deepGrayColor,
                            // buttonColor: popupBgColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
