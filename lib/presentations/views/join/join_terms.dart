import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/routes.dart';
import 'package:step_go/platform/controllers/join_terms_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class JoinTerms extends StatelessWidget {
  const JoinTerms({Key? key}) : super(key: key);

  List<Widget> renderTermsList(JoinTermsController controller) {
    return controller.termsList
        .map(
          (term) => InkWell(
            onTap: () => controller.toggleTerm(term),
            child: Row(
              children: [
                Icon(
                  Icons.check,
                  color: term.isChecked ? Colors.blue : Colors.grey,
                ),
                Text(term.title),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.term, arguments: {'termType': term.termType}),
                      child: const Icon(Icons.chevron_right),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    JoinTermsController controller = Get.put(JoinTermsController());

    return DefaultContainer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('안녕하세요!\nStepGo입니다.'),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('서비스 이용을 위해\n필수 약관에 동의해주세요'),
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
                        const Text('모든 항목 동의하기'),
                      ],
                    ),
                  ),
                  ...renderTermsList(controller),
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
                      onPressed: controller.allAgreed.value ? () => Get.toNamed(Routes.home) : null,
                      child: const Text('다음'),
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
