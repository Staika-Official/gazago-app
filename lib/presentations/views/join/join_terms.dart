import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/join_terms_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class JoinTerms extends StatelessWidget {
  const JoinTerms({Key? key}) : super(key: key);

  List<Widget> renderTermsList(JoinTermsController controller) {
    return controller.termsList
        .map(
          (term) => Padding(
            padding: EdgeInsets.only(left: 0.0.sp),
            child: InkWell(
              onTap: () => controller.toggleTerm(term),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 9.0.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    term.isChecked ? iconCheckAgree : iconCheckDisagree,
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              term.isRequired ? '[필수]' : '[선택]',
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextSecondary,
                                  ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0.sp),
                                child: Text(
                                  term.title!,
                                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                        color: AppColorData.regular().colorTextSecondary,
                                      ),
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
                            child: iconTermsArrowRight,
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

    return WillPopScope(
      onWillPop: () async {
        if (!(controller.platform.value == 'gazago')) {
          Get.find<WalletMasterController>().tabController.animateTo(0);
          Get.back();
        }
        return true;
      },
      child: DefaultContainer(
        isLeadingShow: true,
        onBackButtonTap: () {
          if (!(controller.platform.value == 'gazago')) {
            Get.find<WalletMasterController>().tabController.animateTo(0);
            Get.back();
          }
        },
        backgroundColor: AppColorData.regular().colorBgPrimary,
        child: Padding(
          padding: EdgeInsets.only(left:16.sp, right: 16.sp, top: 16.sp, bottom: 30.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요!',
                    style: AppTextStyleData.regular().koHeadingSemiboldMd.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Text(
                          controller.platform.value == 'gazago' ? 'gazaGO' : 'Staika wallet',
                          style: AppTextStyleData.regular().koHeadingSemiboldMd.copyWith(
                                color: AppColorData.regular().colorTextBrand,
                              ),
                        );
                      }),
                      Text(
                        ' 입니다.',
                        style: AppTextStyleData.regular().koHeadingSemiboldMd.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0.sp),
                child: Text(
                  '서비스 이용을 위해 필수 약관에 동의해주세요',
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
              ),
              Divider(
                height: 64.sp,
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
                              ? iconAllCheckAgree
                              : iconAllCheckDisagree,
                          Padding(
                            padding: EdgeInsets.only(left: 8.0.sp),
                            child: Text(
                              '전체 항목 동의하기',
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 11.0.sp),
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
                    color: controller.allRequiredAgreed.value ? AppColorData.regular().colorBgInteractivePrimary : AppColorData.regular().colorBgInteractivePrimaryDisabled,
                    border: Border.all(width: 2.sp, color: Colors.black),
                    borderRadius: BorderRadius.circular(8.sp),

                  ),
                  child: InkWell(
                    onTap: () => controller.allRequiredAgreed.value ? controller.requestJoin() : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: Text(
                        '다음',
                        style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                              color: controller.allRequiredAgreed.value ? AppColorData.regular().colorBaseBalck : AppColorData.regular().colorTextInverse,
                            ),
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
