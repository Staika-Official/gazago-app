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
  const CreateWalletPassword({Key? key}) : super(key: key);

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
    return DefaultContainer(
      backgroundColor: subBg01Color,
      resizeToAvoidBottomInset: false,
      onBackButtonTap: () {
        Get
            .find<WalletMasterController>()
            .tabController
            .animateTo(0);
        Get.back();
      },
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
                  const TextSpan(
                    text: '안전한 지갑 사용을 위해\n',
                  ),
                  TextSpan(
                    text: '이체 비밀번호',
                    style: TextStyle(color: skyBlueColor),
                  ),
                  const TextSpan(
                    text: '를 등록해주세요.',
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              hintText: '이체 비밀번호를 입력해주세요',
                              hintStyle: TextStyle(
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              hintText: '이체 비밀번호를 확인해주세요',
                              hintStyle: TextStyle(
                                color: deepGrayColor,
                                fontSize: 20,
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
                              if(controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.isAgree.value){
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
          ),


          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => controller.toggleAgree(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.isAgree.value
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
                          padding: EdgeInsets.only(left: 12.0.sp),
                          child: const StyledText(
                            '아래의 내용을 모두 확인했습니다.',
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
                    padding: EdgeInsets.only(top: 28.0.sp),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          color: deepGrayColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
                          fontSize: 12,
                          height: 20 / 12,
                        ),
                        children: [
                          const TextSpan(
                            text: '스타이카 월렛은 ',
                          ),
                          TextSpan(
                            text: '탈중앙화 지갑',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: lightGrayColor,
                            ),
                          ),
                          const TextSpan(
                            text: '이에요. ',
                          ),
                          TextSpan(
                            text: '이체 비밀번호',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: lightGrayColor,
                            ),
                          ),
                          const TextSpan(
                            text: '는 "개인키"이므로 사용자 기기에만 저장되고 관련 정보를 중앙에 일체 저장하지 않고 있어요.\n',
                          ),
                          TextSpan(
                            text: '등록한 이체 비밀번호를 꼭 안전한 곳에 기록하여 보관해주세요!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: lightGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),


          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              child: GazagoButton(
                onTap: () {
                  // print('click');
                  if (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.isAgree.value) {
                    controller.nextStep();
                  }
                },
                buttonText: '확인',
                buttonColor: (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.isAgree.value) ? skyBlueColor : popupBgColor,
                textColor: (controller.confirmPasswordFormStatus.value == FormStatus.sufficient && controller.isAgree.value) ? Colors.black : deepGrayColor,
                // buttonColor: popupBgColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}
