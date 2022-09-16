import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class WithdrawConfirm extends StatelessWidget {
  const WithdrawConfirm({Key? key}) : super(key: key);

  List<Widget> renderCheckList(WithdrawConfirmController controller) {
    return controller.withdrawCheckList
        .map(
          (checkItem) => InkWell(
            onTap: () => controller.toggleCheckList(checkItem),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check,
                  color: checkItem.isChecked ? Colors.blue : Colors.grey,
                ),
                Flexible(child: Text(checkItem.title)),
              ],
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
            SizedBox(
              width: double.infinity,
              child: const Text(
                '정말로 스텝고를 탈퇴하시겠습니까?',
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              height: 40,
              color: Colors.black,
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
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.check_circle_outline,
                                color: Colors.grey,
                              ),
                        const Text('탈퇴 전 꼭 확인해주세요'),
                      ],
                    ),
                  ),
                  ...renderCheckList(controller),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.allAgreed.value ? () => Get.toNamed(Routes.withdrawCompleted) : null,
                      child: const Text('확인'),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
