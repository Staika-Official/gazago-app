import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/join_terms_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class JoinTerms extends StatelessWidget {
  const JoinTerms({Key? key}) : super(key: key);

  List<Widget> renderTermsList(JoinTermsController controller) {
    return controller.termsList
        .map(
          (term) => Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: InkWell(
              onTap: () => controller.toggleTerm(term),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Icon(
                        Icons.check_outlined,
                        color: term.isChecked ? const Color(0xFF0EE6F3) : const Color(0xFF8A8A8A),
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              term.isRequired ? '[필수]' : '[선택]',
                              fontWeight: 500,
                              fontSize: 16,
                              lineHeight: 24,
                              color: const Color(0xFFBFBFBF),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: StyledText(
                                  term.title!,
                                  fontWeight: 500,
                                  fontSize: 16,
                                  lineHeight: 24,
                                  color: const Color(0xFFBFBFBF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (term.boardType != 'SERVICE')
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: SizedBox(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(Routes.term, arguments: {'termType': term.boardType, 'termId': term.id}),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF8A8A8A),
                              size: 20,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    JoinTermsController controller = Get.put(JoinTermsController());

    return DefaultContainer(
      backgroundColor: Color(0xFF1D1D26),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StyledText(
                  '안녕하세요!',
                  fontSize: 24,
                  fontWeight: 700,
                  lineHeight: 24,
                  fontFamily: 'Montserrat',
                ),
                Row(
                  children: const [
                    StyledText(
                      'gazaGO',
                      fontSize: 24,
                      fontWeight: 700,
                      lineHeight: 32,
                      fontFamily: 'Montserrat',
                      color: Color(0xFF0EE6F3),
                    ),
                    StyledText(
                      ' 입니다.',
                      fontSize: 24,
                      fontWeight: 700,
                      lineHeight: 32,
                      fontFamily: 'Montserrat',
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: StyledText(
                '서비스 이용을 위해 필수 약관에 동의해주세요',
                fontSize: 16,
                fontWeight: 500,
              ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          padding: EdgeInsets.only(left: 12.0),
                          child: StyledText(
                            '모든 항목 동의하기',
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        ...renderTermsList(controller),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
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
                onTap: () => controller.requestJoin(),
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
        ),
      ),
    );
  }
}
