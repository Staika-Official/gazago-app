import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class WithdrawConfirm extends StatelessWidget {
  const WithdrawConfirm({Key? key}) : super(key: key);

  List<Widget> renderCheckList(WithdrawConfirmController controller) {
    return controller.withdrawCheckList
        .map(
          (checkItem) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () => controller.toggleCheckList(checkItem),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Icon(
                      Icons.check,
                      color: checkItem.isChecked ? const Color(0xFF0EE6F3) : const Color(0xFF8A8A8A),
                      size: 15,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: StyledText(
                        checkItem.title!,
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 24,
                        color: Color(0xFFBFBFBF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WithdrawConfirmController controller = Get.put(WithdrawConfirmController());

    return DefaultContainer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                StyledText(
                  '정말로 gazaGO 서비스를',
                  fontSize: 22,
                  fontWeight: 700,
                  lineHeight: 22,
                ),
                StyledText(
                  '탈퇴 하시겠습니까?',
                  fontSize: 22,
                  fontWeight: 700,
                  lineHeight: 32,
                  fontFamily: 'Montserrat',
                )
              ],
            ),
            const Divider(
              height: 40,
              color: Color(0xFF363841),
              thickness: 1,
            ),
            Obx(
              () => Column(
                children: [
                  InkWell(
                    onTap: () => controller.toggleAllTerms(),
                    child: Row(
                      children: [
                        controller.allAgreed.value
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF0EE6F3),
                                size: 24,
                              )
                            : const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF363841),
                                size: 24,
                              ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: StyledText(
                            '탈퇴 전 꼭 확인해 주세요.',
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: Column(
                      children: [
                        ...renderCheckList(controller),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Obx(() {
              return Column(
                children: [
                  if (controller.allAgreed.value)
                    Container(
                      height: 55,
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
                        onTap: () => controller.showWithdrawConfirmPopup(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                              child: StyledText(
                            '다음',
                            fontSize: 18,
                            lineHeight: 18,
                            fontWeight: 500,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
