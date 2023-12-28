import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/platform/helpers/preference_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPageController controller = Get.put(MyPageController());

    return DefaultContainer(
      titleText: '계정 정보',
      backgroundColor: subBg01Color,
      headerBackgroundColor: Colors.transparent,
      child: Column(
        children: [
          Obx(() {
            return Container(
              alignment: Alignment.center,
              color: subBg01Color,
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 30.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70.sp,
                    height: 70.sp,
                    child: InkWell(
                      onTap: controller.isEditMode.value ? () => controller.pickImage() : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35.sp,
                            foregroundImage: controller.pickedImage.value != null
                                ? FileImage(
                                    File(controller.pickedImage.value!.path),
                                  )
                                : controller.profile.value.profileImageUrl != null && controller.profile.value.profileImageUrl != ''
                                    ? CachedNetworkImageProvider(
                                        controller.profile.value.profileImageUrl!,
                                        headers: imageNetworkHeader,
                                      )
                                    : Image.asset(
                                        'assets/images/ic_launcher.png',
                                        width: 30.sp,
                                      ).image,
                          ),
                          controller.isEditMode.value
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    child: iconCamera,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.sp),
                    child: controller.isEditMode.value
                        ? Container(
                            constraints: BoxConstraints(minWidth: 80.sp),
                            child: IntrinsicWidth(
                              child: TextField(
                                readOnly: !controller.profile.value.availableChangeNickname!,
                                scrollPadding: EdgeInsets.all(20.0.sp),
                                controller: controller.nicknameTextController,
                                onChanged: (nickName) => controller.updateNickName(nickName),
                                cursorColor: skyBlueColor,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  height: 1.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 4.0.sp),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: popupBgColor,
                                      width: 2.0.sp,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: popupBgColor,
                                      width: 2.0.sp,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: popupBgColor,
                                      width: 2.sp,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  counter: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          height: (16 / 12).sp,
                                          letterSpacing: -0.5,
                                        ),
                                        children: [
                                          controller.profile.value.provider == 'APPLE'
                                              ? TextSpan(
                                                  text: controller.profile.value.nickname!.split('@')[0].length.toString(),
                                                  style: TextStyle(
                                                    color: deepGrayColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                )
                                              : TextSpan(
                                                  text: controller.profile.value.nickname!.length.toString(),
                                                  style: TextStyle(
                                                    color: deepGrayColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                          TextSpan(
                                            text: ' / ',
                                            style: TextStyle(
                                              color: deepGrayColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: controller.maxNickNameLength.toString(),
                                            style: TextStyle(
                                              color: deepGrayColor,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                maxLength: controller.maxNickNameLength,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () => controller.toggleEditMode(),
                            radius: 50.sp,
                            child: Container(
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  bottom: BorderSide(
                                    color: popupBgColor,
                                    width: 2.sp,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.sp, vertical: 2.sp),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    controller.profile.value.provider == 'APPLE'
                                        ? StyledText(
                                            controller.profile.value.nickname!.split('@')[0],
                                            fontSize: 18,
                                            fontWeight: 500,
                                          )
                                        : StyledText(
                                            controller.profile.value.nickname!,
                                            fontSize: 18,
                                            fontWeight: 500,
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.sp, bottom: 4.sp),
                                      child: Icon(
                                        Icons.edit,
                                        color: const Color(0xFFA5A5A5),
                                        size: 14.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              return Column(
                children: [
                  if (controller.isEditMode.value) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 26,
                            left: 20,
                            right: 20,
                            bottom: 90,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff26272F),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                '닉네임 변경 안내',
                                fontSize: 18,
                                fontWeight: 500,
                                lineHeight: 20,
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: StyledText(
                                  '- 닉네임은 앱 사용 시 1회만 변경이 가능합니다. 신중하게 선택해주세요.\n- 욕설, 비방 등의 용어가 포함된 닉네임은 설정이 불가합니다.\n- 금지어가 포함된 닉네임을 설정할 경우, 운영 정책에 따라 가입했던 이메일 주소로 임의로 초기화 될 수 있습니다.',
                                  fontSize: 12,
                                  fontWeight: 500,
                                  lineHeight: 18,
                                  color: deepGrayColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: skyBlueColor,
                      height: 60.sp,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => controller.validateProfileEdit(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                          child: const Center(
                            child: StyledText(
                              '확인',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: 500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else
                    Container(
                      color: subBg02Color,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                        child: Column(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 21.0),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           const StyledText(
                            //             '지갑주소',
                            //             fontSize: 18,
                            //             fontWeight: 500,
                            //             lineHeight: 20,
                            //           ),
                            //           TextButton(
                            //             onPressed: () async => await Clipboard.setData(ClipboardData(text: controller.profile.value.walletAddress)),
                            //             child: Row(
                            //               children: [
                            //                 iconCopy,
                            //                 const Padding(
                            //                   padding: const EdgeInsets.only(left: 8.0),
                            //                   child: StyledText(
                            //                     '주소복사',
                            //                     fontSize: 14,
                            //                     fontWeight: 500,
                            //                     color: Color(0xFFA8A8A8),
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         width: double.infinity,
                            //         child: StyledText(
                            //           controller.profile.value.walletAddress,
                            //           textAlign: TextAlign.end,
                            //           fontWeight: 500,
                            //           color: const Color(0xFF646464),
                            //           fontSize: 12,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 21.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const StyledText(
                                    'SNS 로그인',
                                    fontSize: 18,
                                    fontWeight: 500,
                                    lineHeight: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 5.0.sp, bottom: 3.0.sp),
                                        child: getMypageLoginedButtonIcon(controller.provider.value),
                                      ),
                                      StyledText(
                                        controller.provider.value,
                                        color: const Color(0xFFA8A8A8),
                                        fontSize: 16,
                                        fontWeight: 500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 21.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const StyledText(
                                    '이메일 주소',
                                    fontSize: 18,
                                    fontWeight: 500,
                                    lineHeight: 20,
                                  ),
                                  controller.profile.value.provider == 'APPLE'
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            StyledText(
                                              controller.profile.value.email.split('@')[0],
                                              fontSize: 14,
                                              fontWeight: 500,
                                              color: const Color(0xFFA8A8A8),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5.0.sp),
                                              child: StyledText(
                                                '@${controller.profile.value.email.split('@')[1]}',
                                                fontSize: 14,
                                                fontWeight: 500,
                                                color: const Color(0xFFA8A8A8),
                                              ),
                                            ),
                                          ],
                                        )
                                      : StyledText(
                                          controller.profile.value.email,
                                          fontSize: 14,
                                          fontWeight: 500,
                                          color: const Color(0xFFA8A8A8),
                                        ),
                                ],
                              ),
                            ),

                            // InkWell(
                            //   onTap: () => Get.toNamed(Routes.editBiometrics),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       StyledText(
                            //         '생체정보',
                            //         fontSize: 18,
                            //         fontWeight: 500,
                            //         lineHeight: 20,
                            //       ),
                            //       Icon(Icons.chevron_right),
                            //     ],
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     StyledText(
                            //       '성별',
                            //       fontSize: 18,
                            //       fontWeight: 500,
                            //       lineHeight: 20,
                            //     ),
                            //     StyledText(
                            //       controller.profile.value.gender == 'MALE' ? '남자' : '여자',
                            //       fontSize: 18,
                            //       fontWeight: 500,
                            //     )
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     StyledText(
                            //       '나이',
                            //       fontSize: 18,
                            //       fontWeight: 500,
                            //       lineHeight: 20,
                            //     ),
                            //     StyledText(controller.profile.value.age.toString())
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     StyledText(
                            //       '몸무게',
                            //       fontSize: 18,
                            //       fontWeight: 500,
                            //       lineHeight: 20,
                            //     ),
                            //     StyledText('${controller.profile.value.weight.toString()}kg')
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     StyledText(
                            //       '키',
                            //       fontSize: 18,
                            //       fontWeight: 500,
                            //       lineHeight: 20,
                            //     ),
                            //     StyledText('${controller.profile.value.height.toString()}cm')
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  if (!controller.isEditMode.value)
                    Column(
                      children: [
                        Divider(color: subBg01Color, height: 6.sp),
                        if(controller.profile.value.authorities!.contains('ROLE_CERTIFIED_USER'))
                          Container(
                            color: subBg02Color,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 21.0.sp, horizontal: 20.0.sp),
                              child: InkWell(
                                onTap: () => Get.toNamed(Routes.verificationName),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const StyledText(
                                      '휴대폰 번호 변경하기',
                                      fontSize: 18,
                                      fontWeight: 500,
                                      lineHeight: 20,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: const Color(0xFFBDC0C7),
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Container(
                          color: subBg02Color,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 21.0.sp, horizontal: 20.0.sp),
                            child: InkWell(
                              onTap: () => Get.toNamed(Routes.withdrawConfirm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const StyledText(
                                    '탈퇴하기',
                                    fontSize: 18,
                                    fontWeight: 500,
                                    lineHeight: 20,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: const Color(0xFFBDC0C7),
                                    size: 22.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
