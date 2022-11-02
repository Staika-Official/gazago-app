import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/platform/helpers/preference_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
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
      backgroundColor: Color(0xFF1D1D26),
      headerBackgroundColor: Colors.transparent,
      child: Column(
        children: [
          Obx(() {
            return Container(
              alignment: Alignment.center,
              color: Color(0xFF1D1D26),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: InkWell(
                      onTap: () => controller.pickImage(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            foregroundImage: controller!.pickedImage.value != null
                                ? FileImage(
                                    File(controller.pickedImage.value!.path),
                                  )
                                : CachedNetworkImageProvider(
                                    controller.profile.value.profileImageUrl!,
                                  ) as ImageProvider,
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
                    padding: EdgeInsets.only(top: 10),
                    child: controller.isEditMode.value
                        ? Container(
                            constraints: BoxConstraints(minWidth: 80),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: controller.nicknameTextController,
                                onChanged: (nickName) => controller.updateNickName(nickName),
                                cursorColor: Color(0xFF0EE6F3),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff363841),
                                      width: 2.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff363841),
                                      width: 2.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff363841),
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  counter: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 16 / 12,
                                          letterSpacing: -0.5,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: controller.profile.value.nickname!.length.toString(),
                                            style: const TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' / ',
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                            ),
                                          ),
                                          TextSpan(
                                            text: controller.maxNickNameLength.toString(),
                                            style: const TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 12,
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
                        : Container(
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(
                                  color: Color(0xff363841),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StyledText(
                                    controller.profile.value.nickname!,
                                    fontSize: 18,
                                    fontWeight: 500,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, bottom: 4),
                                    child: InkWell(
                                      onTap: () => controller.toggleEditMode(),
                                      radius: 50,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color(0xFFA5A5A5),
                                        size: 14,
                                      ),
                                    ),
                                  )
                                ],
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
                  controller.isEditMode.value
                      ? Expanded(
                          child: Container(
                              color: Color(0xFF1D1D26),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: const Color(0xFF0EE6F3),
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () => controller.modifyMyAccountInfo(),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Center(
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
                              )),
                        )
                      : Container(
                          color: Color(0xFF2A2B33),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  padding: const EdgeInsets.symmetric(vertical: 21.0),
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
                                            padding: const EdgeInsets.only(right: 5.0, bottom: 3.0),
                                            child: getMypageLoginedButtonIcon(controller.profile.value.provider!),
                                          ),
                                          StyledText(
                                            controller.profile.value.provider!,
                                            color: Color(0xFFA8A8A8),
                                            fontSize: 16,
                                            fontWeight: 500,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 21.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const StyledText(
                                        '이메일 주소',
                                        fontSize: 18,
                                        fontWeight: 500,
                                        lineHeight: 20,
                                      ),
                                      StyledText(
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
                        const Divider(color: Color(0xFF1D1D26), height: 6),
                        Container(
                          color: const Color(0xFF2A2B33),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 20.0),
                            child: InkWell(
                              onTap: () => Get.toNamed(Routes.withdrawConfirm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  StyledText(
                                    '탈퇴하기',
                                    fontSize: 18,
                                    fontWeight: 500,
                                    lineHeight: 20,
                                  ),
                                  Icon(Icons.chevron_right, color: Color(0xFFBDC0C7)),
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
