import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class WithdrawCompleted extends StatelessWidget {
  const WithdrawCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('회원 탈퇴 완료'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('그동안 이용해 주셔서 감사합니다.'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.login),
              child: Text('확인'),
            ),
          )
        ],
      ),
    );
  }
}
