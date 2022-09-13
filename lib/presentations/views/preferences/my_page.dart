import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(
                    controller.profile.value.profileImageUrl,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller.profile.value.nickname),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: InkWell(
                          onTap: () => null,
                          radius: 50,
                          child: Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
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
                    children: [
                      Text('SNS 로그인'),
                      Text(controller.profile.value.socialAccounts)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('이메일 주소'),
                      Text(controller.profile.value.email)
                    ],
                  ),
                  InkWell(
                    onTap: () => null,
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
                    children: [
                      Text('나이'),
                      Text(controller.profile.value.age.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('몸무게'),
                      Text('${controller.profile.value.weight.toString()}kg')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('키'),
                      Text('${controller.profile.value.height.toString()}cm')
                    ],
                  ),
                  InkWell(
                    onTap: () => null,
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
            ),
          )
        ],
      ),
    );
  }
}
