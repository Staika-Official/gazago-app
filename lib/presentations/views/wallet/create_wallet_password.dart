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
import 'package:get/get.dart';

class CreateWalletPassword extends StatelessWidget {
  const CreateWalletPassword({super.key});

  Widget validatePassword(FormStatus status) {
    return Visibility(
      visible: status != FormStatus.empty,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: status == FormStatus.insufficient ? iconPasswordInvalid : iconPasswordValid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CreateWalletPasswordController controller = Get.put(CreateWalletPasswordController());
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
                        children: const [
                          TextSpan(
                            text: '안전한 지갑 사용을 위해\n',
                          ),
                          TextSpan(
                            text: '이체 비밀번호',
                            style: TextStyle(color: skyBlueColor),
                          ),
                          TextSpan(
                            text: '를 등록해주세요.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
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
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                    hintText: '이체 비밀번호를 입력해주세요',
                                    hintStyle: TextStyle(
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
                                  onChanged: (password) => controller.updatePassword(password),
                                ),
                              ),
                              Obx(() => validatePassword(controller.passwordFormStatus.value)),
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
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15.sp),
                                    hintText: '이체 비밀번호를 확인해주세요',
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
                                  onChanged: (password) => controller.updateConfirmPassword(password),
                                  onSubmitted: (password) {
                                    if (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.confirmTextStatus.value == FormStatus.sufficient) {
                                      controller.nextStep();
                                    }
                                  },
                                ),
                              ),
                              Obx(() => validatePassword(controller.confirmPasswordFormStatus.value)),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            '• 8~16자로 영문, 숫자, 특수문자가 조합해주세요.',
                            style: TextStyle(
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
                            padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 12.sp),
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
                                        child: const StyledText(
                                          '비밀번호 등록 전에 꼭 확인하세요!',
                                          color: Color(0XFFEB4C4C),
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
                                  child: const Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '스타이카 월렛은 탈중앙화 지갑이에요',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '이체 비밀번호는 ‘개인키’이므로 저희 서비스에서는 일체 보관하지 않고 있어요.',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '이체 비밀번호를 분실할 시 계정을 복구할 수 없어요.',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '이체 비밀번호를 안전한 곳에 기록하여 보관해 주세요.',
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
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      hintText: '확인했습니다',
                                      hintStyle: TextStyle(
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
                                    onChanged: (text) => controller.updateConfirmText(text),
                                  ),
                                ),
                                Obx(() => validatePassword(controller.confirmTextStatus.value)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.sp, left: 15.0.sp),
                          child: const StyledText(
                            '위 내용을 인지했다면 \'확인했습니다\'를 입력해주세요',
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
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          width: double.infinity,
                          child: GazagoButton(
                            onTap: () {
                              // print('click');
                              if (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.confirmTextStatus.value == FormStatus.sufficient) {
                                controller.nextStep();
                              }
                            },
                            buttonText: '확인',
                            buttonColor:
                                (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.confirmTextStatus.value == FormStatus.sufficient) ? skyBlueColor : popupBgColor,
                            textColor:
                                (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.confirmTextStatus.value == FormStatus.sufficient) ? Colors.black : deepGrayColor,
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
