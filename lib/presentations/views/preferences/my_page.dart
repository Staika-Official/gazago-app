import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/routes.dart';
import 'package:step_go/platform/controllers/my_page_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPageController controller = Get.put(MyPageController());

    return DefaultContainer(
      child: Column(
        children: [
          Obx(() {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          foregroundImage: controller!.pickedImage.value != null
                              ? FileImage(
                                  File(controller.pickedImage.value!.path),
                                )
                              : CachedNetworkImageProvider(
                                  controller.profile.value.profileImageUrl,
                                ) as ImageProvider,
                        ),
                        controller.isEditMode.value
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => controller.pickedImage,
                                  child: Icon(Icons.change_circle),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: controller.isEditMode.value
                        ? TextField(
                            controller: controller.nicknameTextController,
                            onChanged: (nickName) => controller.updateNickName(nickName),
                            cursorColor: Colors.black,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffA5A5A5),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffA5A5A5),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              counter: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Color(0xffa8a8a8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 20 / 12,
                                      letterSpacing: -0.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller.profile.value.nickname.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' / ',
                                      ),
                                      TextSpan(text: controller.maxNickNameLength.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            maxLength: controller.maxNickNameLength,
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(controller.profile.value.nickname),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: InkWell(
                                  onTap: () => controller.toggleEditMode(),
                                  radius: 50,
                                  child: Icon(Icons.edit),
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              return Container(
                child: controller.isEditMode.value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.toggleEditMode(),
                            child: Text('확인'),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('지갑주소'),
                                  TextButton(
                                    onPressed: () => null,
                                    child: Row(
                                      children: [
                                        Icon(Icons.copy),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text('주소복사'),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  controller.profile.value.walletAddress,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('SNS 로그인'), Text(controller.profile.value.socialAccounts)],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('이메일 주소'), Text(controller.profile.value.email)],
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(Routes.editBiometrics),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('생체정보'),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('성별'),
                              Text(
                                controller.profile.value.gender == 'MALE' ? '남자' : '여자',
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('나이'), Text(controller.profile.value.age.toString())],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('몸무게'), Text('${controller.profile.value.weight.toString()}kg')],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('키'), Text('${controller.profile.value.height.toString()}cm')],
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(Routes.withdrawConfirm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('탈퇴하기'),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ],
                      ),
              );
            }),
          )
        ],
      ),
    );
  }
}
