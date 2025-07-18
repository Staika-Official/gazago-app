import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/term_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class Term extends StatelessWidget {
  const Term({super.key});

  @override
  Widget build(BuildContext context) {
    TermController controller = Get.put(TermController());

    return Obx(() {
      return DefaultContainer(
        backgroundColor: subBg01Color,
        titleText: controller.termTitle.value,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              if (controller.termType.value == 'MARKETING' &&
                  Get.previousRoute != Routes.joinTerms)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.sp, vertical: 15.sp),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2.sp,
                        color: popupBgColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText(
                        'marketing_info_consent_1'.tr(),
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: Colors.white,
                      ),
                      Switch.adaptive(
                        activeColor: skyBlueColor,
                        activeTrackColor: skyBlueColor,
                        inactiveTrackColor:
                            const Color.fromRGBO(120, 120, 128, 0.16),
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        value: controller.agreeMarketing.value,
                        onChanged: (val) => controller.toggleSwitch(val),
                      )
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(25.sp),
                child: StyledText(
                  controller.termContent.value,
                  fontSize: 16,
                  fontWeight: 500,
                  lineHeight: 24,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
