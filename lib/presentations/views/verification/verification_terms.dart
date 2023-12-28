import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/verification_terms_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class VerificationTerms extends StatelessWidget {
  const VerificationTerms({Key? key}) : super(key: key);

  List<Widget> renderTermsList(VerificationTermsController controller) {
    return controller.termsList
        .map(
          (term) => Padding(
            padding: EdgeInsets.only(left: 4.0.sp),
            child: InkWell(
              onTap: () => controller.toggleTerm(term),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.0.sp),
                      child: Icon(
                        Icons.check_outlined,
                        color: term.isChecked ? skyBlueColor : deepGrayColor,
                        size: 15.sp,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 18.0.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              term.isRequired ? '[필수]' : '[선택]',
                              fontWeight: 500,
                              fontSize: 16,
                              lineHeight: 24,
                              color: lightGrayColor,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0.sp),
                                child: StyledText(
                                  term.title!,
                                  fontWeight: 500,
                                  fontSize: 16,
                                  lineHeight: 24,
                                  color: lightGrayColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(term.content != null && term.content != '')
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.sp),
                      child: SizedBox(
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.term, arguments: {'termType': term.boardType, 'termId': term.id}),
                          child: Icon(
                            Icons.chevron_right,
                            color: deepGrayColor,
                            size: 20.sp,
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
    VerificationTermsController controller = Get.put(VerificationTermsController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StyledText(
                      'gazaGO',
                      fontSize: 24,
                      fontWeight: 700,
                      lineHeight: 32,
                      fontFamily: 'Montserrat',
                      color: skyBlueColor,
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0.sp),
              child: const StyledText(
                '본인인증이 필요합니다.',
                fontSize: 24,
                lineHeight: 26,
                fontWeight: 500,
              ),
            ),
            Divider(
              height: 40.sp,
              color: popupBgColor,
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
                            ? Icon(
                                Icons.check_circle,
                                color: skyBlueColor,
                                size: 24.sp,
                              )
                            : Icon(
                                Icons.check_circle_rounded,
                                color: popupBgColor,
                                size: 24.sp,
                              ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0.sp),
                          child: const StyledText(
                            '필수항목 모두 동의하기',
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
                    padding: EdgeInsets.only(top: 8.0.sp),
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
            Obx(() {
              return Container(
                height: 55.sp,
                decoration: BoxDecoration(
                  color: controller.allAgreed.value ? skyBlueColor : popupBgColor,
                  border: Border.all(width: 2.sp, color: Colors.black),
                  borderRadius: BorderRadius.circular(8.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 3.sp),
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () => controller.allAgreed.value ? controller.nextStep() : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                    child: Center(
                        child: StyledText(
                      '다음',
                      fontSize: 18,
                      lineHeight: 18,
                      fontWeight: 500,
                      color: controller.allAgreed.value ? Colors.black : deepGrayColor,
                    )),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
