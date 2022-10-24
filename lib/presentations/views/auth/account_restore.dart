import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class AccountRestore extends StatelessWidget {
  const AccountRestore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      backgroundColor: const Color(0xFF1D1D26),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        StyledText(
                          '기존 회원 정보로 계정이 복구 됩니다.',
                          fontSize: 22,
                          fontWeight: 500,
                          lineHeight: 22,
                          letterSpacing: .1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0),
                          child: StyledText(
                            '탈퇴 후 14일 내 로그인 시\n기존 회원 계정으로 복구 됩니다.\n복구 하시겠습니까?',
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 22,
                            letterSpacing: .1,
                            textAlign: TextAlign.center,
                            color: Color(0xFF8A8A8A),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF363841),
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: Center(
                                child: StyledText(
                              '아니요',
                              fontSize: 18,
                              lineHeight: 18,
                              fontWeight: 500,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EE6F3),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () => null,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          child: Center(
                              child: StyledText(
                            '계정 해제 진행',
                            fontSize: 18,
                            lineHeight: 18,
                            fontWeight: 500,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
