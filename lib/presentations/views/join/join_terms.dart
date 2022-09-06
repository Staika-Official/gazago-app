import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/join_terms_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class JoinTerms extends StatelessWidget {
  JoinTerms({Key? key}) : super(key: key);

  List<Widget> renderTermsList(JoinTermsController controller) {
    return controller.termsList.value
        .map((term) => InkWell(
              onTap: () => controller.toggleTerm(term),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: term.isChecked ? Colors.blue : Colors.grey,
                  ),
                  Text(term.title),
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    JoinTermsController controller = Get.put(JoinTermsController());
    return DefaultContainer(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('안녕하세요!\nStepGo입니다.'),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text('서비스 이용을 위해\n필수 약관에 동의해주세요'),
            ),
            Divider(
              height: 40,
              color: Colors.black,
              thickness: 1,
            ),
            Obx(
              () => Container(
                child: Column(
                  children: [...renderTermsList(controller)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
