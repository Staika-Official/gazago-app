import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/join_terms_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class JoinTerms extends StatelessWidget {
  const JoinTerms({super.key});

  List<Widget> renderTermsList(JoinTermsController controller) {
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
                    if (term.boardType != 'SERVICE')
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.sp),
                        child: SizedBox(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(Routes.term, arguments: {'platform': controller.platform.value, 'termType': term.boardType, 'termId': term.id}),
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
    JoinTermsController controller = Get.put(JoinTermsController());

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (!(controller.platform.value == 'gazago')) {
          Get.find<WalletMasterController>().tabController.animateTo(0);
          Get.back();
        }
      },
      child: DefaultContainer(
        isLeadingShow: true,
        onBackButtonTap: () {
          if (!(controller.platform.value == 'gazago')) {
            Get.find<WalletMasterController>().tabController.animateTo(0);
            Get.back();
          }
        },
        backgroundColor: subBg01Color,
        child: Padding(
          padding: EdgeInsets.all(20.sp),
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
                    children: [
                      Obx(() {
                        return StyledText(
                          controller.platform.value == 'gazago' ? 'gazaGO' : '스타이카 월렛',
                          fontSize: 24,
                          fontWeight: 700,
                          lineHeight: 32,
                          fontFamily: 'Montserrat',
                          color: skyBlueColor,
                        );
                      }),
                      const StyledText(
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
              Padding(
                padding: EdgeInsets.only(top: 30.0.sp),
                child: const StyledText(
                  '서비스 이용을 위해 필수 약관에 동의해주세요',
                  fontSize: 16,
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
                    color: controller.allRequiredAgreed.value ? skyBlueColor : popupBgColor,
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
                    onTap: () => controller.allRequiredAgreed.value ? controller.requestJoin() : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: StyledText(
                        '다음',
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: controller.allRequiredAgreed.value ? Colors.black : deepGrayColor,
                      )),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
