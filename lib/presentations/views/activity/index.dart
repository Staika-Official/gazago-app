import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ActivityHome extends StatelessWidget {
  const ActivityHome({super.key});

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.sp),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              height: 36.sp,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: stat.type == 'STAMINA'
                              ? SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.sp),
                                    ),

                                  ),
                                ),
                                stat.currentStat > 1.0
                                    ? LayoutBuilder(builder: (context, constraints) {
                                  return Container(
                                    width: stat.currentStat > 20
                                        ? constraints.maxWidth / (100 / stat.currentStat)
                                        : stat.currentStat < 2
                                        ? 0
                                        : 34,
                                    decoration: BoxDecoration(
                                      color: stat.currentStat <= 30 ? AppColorData
                                          .regular()
                                          .colorBgWarning : AppColorData
                                          .regular()
                                          .colorPointYellowgreen,
                                      border: Border.all(
                                        width: 2.sp,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     offset: const Offset(1, 0),
                                      //     blurRadius: 0.0,
                                      //     spreadRadius: 0.0,
                                      //   ),
                                      // ],

                                    ),
                                  );
                                })
                                    : Container(),
                              ],
                            ),
                          )
                              : SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(42.sp),
                                    ),
                                    // boxShadow: const [
                                    //   BoxShadow(
                                    //     color: Colors.black,
                                    //     offset: Offset(1, 0),
                                    //     blurRadius: 0.0,
                                    //     spreadRadius: 0.0,
                                    //   ),
                                    // ],

                                  ),
                                ),
                                stat.currentStat > 1.0
                                    ? LayoutBuilder(builder: (context, constraints) {
                                  return Container(
                                    width: stat.currentStat > 20
                                        ? constraints.maxWidth / (100 / stat.currentStat)
                                        : stat.currentStat < 2
                                        ? 0
                                        : 34,
                                    decoration: BoxDecoration(
                                      color: stat.currentStat <= 30 ? AppColorData
                                          .regular()
                                          .colorBgWarning : AppColorData
                                          .regular()
                                          .colorPointPurple,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     offset: const Offset(1, 0),
                                      //     blurRadius: 4.0,
                                      //     spreadRadius: 0.0,
                                      //   ),
                                      // ],
                                    ),
                                  );
                                })
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          stat.type == 'STAMINA'
                              ? Padding(
                            padding: EdgeInsets.only(left: 17.0.sp, right: 5.sp),
                            child: iconStamina,
                          )
                              : Padding(
                            padding: EdgeInsets.only(left: 15.0.sp, right: 3.sp),
                            child: iconShoes,
                          ),
                          Text(
                            stat.name,
                            style: AppTextStyleData
                                .regular()
                                .koBodySemiboldMd
                                .copyWith(
                                height: 1.1,
                                color: stat.currentStat <= 30 ? AppColorData
                                    .regular()
                                    .colorTextPrimary : AppColorData
                                    .regular()
                                    .colorTextInverse
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: Text(
                              formatDecimalPlaces(stat.currentStat, 2),
                              style: AppTextStyleData
                                  .regular()
                                  .enBodySemiboldMd
                                  .copyWith(
                                  height: 1.1,
                                  color: stat.currentStat <= 30 ? AppColorData
                                      .regular()
                                      .colorTextPrimary : AppColorData
                                      .regular()
                                      .colorTextInverse
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          stat.type == 'STAMINA'
                              ? Container(
                            decoration: BoxDecoration(
                              color: gaugeGrayColor,
                              border: Border.all(
                                width: 1.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.sp),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 17.sp,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorPointYellowgreen,
                              child: IconButton(
                                icon: iconRepairPlus,
                                splashRadius: 17.sp,
                                onPressed: () => {controller.onClickRepairStat(stat, context)},
                              ),
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: gaugeGrayColor,
                              border: Border.all(
                                width: 1.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.sp),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 17.sp,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorPointPurple,
                              child: IconButton(
                                icon: iconRepairPlus,
                                splashRadius: 17.sp,
                                onPressed: () => {controller.onClickRepairStat(stat, context)},
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();
    DailyBenefitController dailyBenefitController = Get.isRegistered<DailyBenefitController>() ? Get.find<DailyBenefitController>() : Get.put(DailyBenefitController());
    var challengeMovie = MovieTween()
      ..scene(begin: const Duration(seconds: 1), duration: const Duration(seconds: 2))
          .thenTween('width', Tween<double>(begin: 70.sp, end: 250.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('opacity', Tween<double>(begin: 0, end: 1), curve: Curves.easeOut)
          .thenFor(duration: const Duration(seconds: 5))
          .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('width', Tween<double>(begin: 250.sp, end: 70.sp), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 0, end: 10.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 10.sp, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

    return LayoutBuilder(
      builder: (context, constraint) {
        return Obx(() {
          return Container(
            decoration: BoxDecoration(

              color: AppColorData
                  .regular()
                  .colorBgPrimary,
              image: DecorationImage(
                image: AssetImage('assets/images/bg_activity_road.png'),
                alignment: Alignment(100, 1.45),
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 0.sp),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 14.0.sp),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColorData
                                  .regular()
                                  .colorBgSecondary,

                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDoubleData
                                    .regular()
                                    .numberRadius12),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  spreadRadius: 0,
                                  blurRadius: 0,
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 28.0.sp, bottom: 26.0.sp),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColorData
                                              .regular()
                                              .colorBgPrimary,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(11.3.sp),
                                          child: iconActivityTokenGo,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'TODAY',
                                              style: AppTextStyleData
                                                  .regular()
                                                  .enBodyMediumMd
                                                  .copyWith(
                                                color: AppColorData
                                                    .regular()
                                                    .colorTextSecondary,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  controller.userState.value.state != null ? formatDecimalPlaces(controller.userState.value.state!.dailyGoReward!, 2) : formatDecimalPlaces(0, 2),
                                                  style: AppTextStyleData
                                                      .regular()
                                                      .enHeadingBoldLg
                                                      .copyWith(
                                                    color: AppColorData
                                                        .regular()
                                                        .colorTextBrand,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 4.0.sp, right: 5.0.sp),
                                                  child: Text(
                                                    'GO',
                                                    style: AppTextStyleData
                                                        .regular()
                                                        .enHeadingMediumSm
                                                        .copyWith(
                                                      color: AppColorData
                                                          .regular()
                                                          .colorTextSecondary,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],

                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 14.0.sp, bottom: 10.sp),
                                    child: Divider(
                                      color: AppColorData
                                          .regular()
                                          .colorBorderInverse,
                                      thickness: 1,
                                      height: 1,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ...renderStatList(controller, context),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.sp),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await dailyBenefitController.refreshController();
                                    Adjust.trackEvent(AdjustEvent('h199wc'));
                                    Get.toNamed(Routes.dailyBenefits);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColorData
                                          .regular()
                                          .colorBgSecondary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(AppDoubleData
                                            .regular()
                                            .numberRadius12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0.sp),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '일일혜택',
                                            style: AppTextStyleData
                                                .regular()
                                                .enBodyMediumLg
                                                .copyWith(
                                              color: AppColorData
                                                  .regular()
                                                  .colorTextPrimary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.0.sp),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '광고보고\n리워드 받기!',
                                                  style: AppTextStyleData
                                                      .regular()
                                                      .enBodyMediumMd
                                                      .copyWith(
                                                    color: AppColorData
                                                        .regular()
                                                        .colorTextSecondary,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                iconDailyMission
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.sp,),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColorData
                                        .regular()
                                        .colorBgSecondary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDoubleData
                                          .regular()
                                          .numberRadius12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0.sp),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '컬렉션',
                                          style: AppTextStyleData
                                              .regular()
                                              .enBodyMediumLg
                                              .copyWith(
                                            color: AppColorData
                                                .regular()
                                                .colorTextPrimary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.0.sp),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '재료를 모아\n리워드 받기!',
                                                style: AppTextStyleData
                                                    .regular()
                                                    .enBodyMediumMd
                                                    .copyWith(
                                                  color: AppColorData
                                                      .regular()
                                                      .colorTextSecondary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              iconCollection
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Center(
                                  child: Obx(() {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: skyBlueColor,
                                            border: Border.all(width: 10.sp, color: const Color(0xFF4A4D57)),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(150),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black,
                                                offset: Offset(0, 6),
                                                blurRadius: 0.0,
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 4.sp,
                                                color: AppColorData
                                                    .regular()
                                                    .colorBorderPrimary,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(150),
                                              ),
                                            ),
                                            child: MaterialButton(
                                              onPressed: controller.disableActivityButton.value
                                                  ? null
                                                  : [ExerciseState.ongoing, ExerciseState.paused, ExerciseState.ready].any((state) => controller.exerciseState.value == state)
                                                  ? () => controller.requestExerciseInitialization()
                                                  : () => showToastPopup('지속적으로 문제가 발생한다면 앱을 재시작해주세요'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(150),
                                              ),
                                              color: skyBlueColor,
                                              height: 148.sp,
                                              minWidth: 148.sp,
                                              child: controller.disableActivityButton.value
                                                  ? Text(
                                                '준비중..',
                                                style: AppTextStyleData
                                                    .regular()
                                                    .koHeadingBold2xl
                                                    .copyWith(
                                                  color: AppColorData
                                                      .regular()
                                                      .colorTextInverse,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                                  : Text(
                                                [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? '계속' : '시작',
                                                style: AppTextStyleData
                                                    .regular()
                                                    .koHeadingBold2xl
                                                    .copyWith(
                                                  color: AppColorData
                                                      .regular()
                                                      .colorTextInverse,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
