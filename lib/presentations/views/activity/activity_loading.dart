import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart' hide Trans;
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../styles/styled_text.dart';

class ActivityLoading extends StatelessWidget {
  final ExerciseType exerciseType;
  final String? adId;
  final ChallengeCourseModel? challenge;
  const ActivityLoading(
      {super.key, required this.exerciseType, this.adId, this.challenge});

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();
    return PopScope(
      canPop: false,
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: CustomAnimationBuilder<double>(
                  control: controller.activityLoadControl,
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: controller.loadingTime.value < 4
                        ? Image.asset(
                            'assets/images/activity/ico_loading_${controller.loadingTime.value}.png')
                        : Container(),
                  ),
                ),
              ),
              // GPS Status Message
              Positioned(
                left: 0,
                bottom: 120.sp,
                right: 0,
                child: Center(
                  child: Obx(() {
                    String statusMessage;
                    if (controller.loadingTime.value < 3) {
                      statusMessage = 'preparing'.tr();
                    } else if (!UnifiedGPSManager.instance.isReady.value) {
                      statusMessage = 'acquiring_gps_signal'.tr();
                    } else {
                      statusMessage = 'ready'.tr();
                    }
                    
                    return StyledText(
                      statusMessage,
                      color: UnifiedGPSManager.instance.isReady.value ? Colors.green : lightGrayColor,
                      fontSize: 16,
                      lineHeight: 18,
                      fontWeight: 400,
                    );
                  }),
                ),
              ),
              // Skip Button (only show after minimum time and conditionally)
              Positioned(
                left: 0,
                bottom: 50.sp,
                right: 0,
                child: Center(
                  child: Obx(() {
                    // Only show skip if GPS is ready or after timeout
                    bool canSkip = UnifiedGPSManager.instance.isReady.value || controller.loadingTime.value >= 12;
                    
                    return canSkip ? InkWell(
                      onTap: () => controller.passThrowActivityLoading(
                          exerciseType, challenge),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: lightGrayColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4.0.sp),
                            child: StyledText(
                              'skip_action'.tr(),
                              color: lightGrayColor,
                              fontSize: 18,
                              lineHeight: 20,
                              fontWeight: 500,
                            ),
                          ),
                        ),
                      ),
                    ) : const SizedBox.shrink();
                  }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
