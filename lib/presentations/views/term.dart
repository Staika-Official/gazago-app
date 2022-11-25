import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/term_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Term extends StatelessWidget {
  const Term({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TermController controller = Get.put(TermController());

    return Obx(() {
      return DefaultContainer(
        titleText: controller.termTitle.value,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              if (controller.termType.value == 'T2E_MARKETING')
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 15.sp),
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
                      const StyledText(
                        '마케팅 정보 수신 동의',
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                        color: Colors.white,
                      ),
                      Switch.adaptive(
                        activeColor: skyBlueColor,
                        activeTrackColor: skyBlueColor,
                        inactiveTrackColor: const Color.fromRGBO(120, 120, 128, 0.16),
                        thumbColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
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
