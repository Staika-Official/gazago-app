import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/benefit_item_model.dart';
import 'package:gaza_go/presentations/components/beta_tag.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class DailyBenefits extends StatelessWidget {
  const DailyBenefits({super.key});

  Widget _renderTitleText(String title) {
    List<String> list = title.split(RegExp(r'([0-9]+(\s|\S)TIK)|([0-9]+(\s|\S)GO)|(아이템)'));
    List<String?> keywords = RegExp(r'([0-9]+(\s|\S)TIK)|([0-9]+(\s|\S)GO)|(아이템)').allMatches(title).map((match) => match.group(0)).toList();
    List<TextSpan> textSpanList = List.empty(growable: true);

    for (int idx = 1; idx < list.length; idx++) {
      textSpanList.add(
        TextSpan(
          text: keywords[idx - 1],
          style: const TextStyle(
            color: skyBlueColor,
          ),
        ),
      );

      textSpanList.add(
        TextSpan(
          text: list[idx],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xffF9F9F9),
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: 'Pretendard',
          height: 20 / 18,
        ),
        children: [
          TextSpan(
            text: list.first,
          ),
          ...textSpanList,
        ],
      ),
    );
  }

  List<Widget> _renderDailyBenefitList(DailyBenefitController controller) {
    return controller.dailyBenefitList.value!.benefits.asMap().entries.map(
      (item) {
        bool locked = true;
        if (item.key == 0) {
          locked = false;
        } else {
          if (!controller.dailyBenefitList.value!.benefits[item.key - 1].received) {
            locked = true;
          } else {
            locked = false;
          }
        }

        return DailyBenefitItem(
          userDistance: controller.dailyBenefitList.value!.userExercise.distance!,
          benefitItem: item.value,
          locked: locked,
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    DailyBenefitController controller = Get.find<DailyBenefitController>();

    return Obx(() {
      return DefaultContainer(
        backgroundColor: subBg01Color,
        titleWidget: const Stack(
          clipBehavior: Clip.none,
          children: [
            StyledText(
              '일일혜택',
              fontSize: 18,
              fontWeight: 500,
              lineHeight: 18,
            ),
            Positioned(
              right: -45,
              top: -3,
              child: BetaTag(),
            )
          ],
        ),
        child: RefreshIndicator(
          onRefresh: () => controller.refreshController(),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: StyledText(
                      controller.formattedDate.value,
                      fontSize: 16,
                      lineHeight: 16,
                      fontWeight: 500,
                      letterSpacing: -0.1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26, bottom: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StyledText(
                          controller.dailyBenefitList.value!.userExercise.distance! >= 1000
                              ? formatDecimalPlaces(double.parse(formatMeterToKilometer(controller.dailyBenefitList.value!.userExercise.distance!.toInt())), 1, roundType: RoundType.floor)
                              : formatDecimalPlaces(controller.dailyBenefitList.value!.userExercise.distance!, 0),
                          fontFamily: 'Montserrat',
                          fontSize: 50,
                          lineHeight: 50,
                          fontWeight: 500,
                          letterSpacing: -0.3,
                        ),
                        StyledText(
                          controller.dailyBenefitList.value!.userExercise.distance! >= 1000 ? 'km' : 'm',
                          fontFamily: 'Montserrat',
                          fontSize: 50,
                          lineHeight: 50,
                          fontWeight: 400,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const StyledText(
                        '현재 거리',
                        fontSize: 16,
                        lineHeight: 16,
                        fontWeight: 500,
                        color: lightGrayColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Ink(
                          width: 24,
                          height: 24,
                          child: InkWell(
                            onTap: () => controller.refreshController(),
                            borderRadius: BorderRadius.circular(24),
                            child: iconRefresh,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 25),
                    child: SizedBox(
                      width: 310,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: popupBgColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 310 *
                                  (controller.dailyBenefitList.value!.userExercise.distance! >= controller.maxRewardDistance.value
                                      ? 1
                                      : controller.dailyBenefitList.value!.userExercise.distance! / controller.maxRewardDistance.value),
                              height: 16,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  transform: GradientRotation(2.3911),
                                  colors: [
                                    skyBlueColor,
                                    Color(0xff0EF3D8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 20.sp, right: 20.sp, bottom: 24),
                        child: Row(
                          children: [
                            _renderTitleText(controller.dailyBenefitList.value!.label),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0.sp, bottom: 2),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Get.dialog(
                                    barrierColor: Colors.black.withOpacity(.8),
                                    Material(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.only(top: 44.sp, left: 29.sp, right: 29.sp, bottom: 42.sp),
                                                    decoration: BoxDecoration(
                                                      color: popupBgColor,
                                                      borderRadius: BorderRadius.circular(10.sp),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const StyledText(
                                                          '일일 혜택 안내',
                                                          fontSize: 18,
                                                          fontWeight: 700,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 29.sp),
                                                          child: const Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              StyledText(
                                                                '일일 혜택은 광고 수익으로 운영되며, 광고를 시청하신 후에 보상으로 아이템 또는 TIK등을 받을 수 있어요. \n최대한 혜택을 드리고자, 다소 길이가 길거나 불필요하게 느껴지는 광고가 나올 수 있다는 점 양해 부탁드려요. \n일일 혜택은 현재 베타로 운영되고 있으며, 상황에 따라 사전 고지 없이 변경될 수 있어요.',
                                                                fontSize: 14,
                                                                fontWeight: 600,
                                                                lineHeight: 24,
                                                                letterSpacing: -0.3,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 12,
                                                    top: 12,
                                                    child: InkWell(
                                                      onTap: () => Get.back(),
                                                      child: iconCloseWhite,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  icon: iconInfo,
                                  splashRadius: 15.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  controller.dataGetLoading.value
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : controller.dailyBenefitList.value != null && controller.dailyBenefitList.value!.benefits.isEmpty
                          ? const SizedBox(
                              height: 200,
                              child: Center(
                                child: StyledText(
                                  '일일 혜택이 없습니다.',
                                  fontSize: 16,
                                  fontWeight: 600,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 18.sp,
                                crossAxisSpacing: 10.sp,
                                childAspectRatio: 110.sp / 147.sp,
                                physics: const ClampingScrollPhysics(),
                                padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
                                shrinkWrap: true,
                                children: [
                                  ..._renderDailyBenefitList(controller),
                                ],
                              ),
                            )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DailyBenefitItem extends StatefulWidget {
  double userDistance;
  BenefitItemModel benefitItem;
  bool locked;

  DailyBenefitItem({
    super.key,
    required this.userDistance,
    required this.benefitItem,
    required this.locked,
  });

  @override
  State<DailyBenefitItem> createState() => _DailyBenefitItemState();
}

class _DailyBenefitItemState extends State<DailyBenefitItem> {
  bool _loading = false;

  void toggleLoadingState() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    DailyBenefitController controller = Get.find<DailyBenefitController>();

    return Container(
      decoration: BoxDecoration(
        color: subBg02Color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(1, 2),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (widget.benefitItem.adDisplayed)
            Positioned(
              top: 8.sp,
              right: 8.sp,
              child: Container(
                width: 22,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: GradientRotation(2.3911),
                    colors: [
                      skyBlueColor,
                      Color(0xff0EF3D8),
                    ],
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/images/ico_ad.svg'),
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 15, left: 10.sp, right: 10.sp, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.userDistance < widget.benefitItem.distance
                    ? SvgPicture.asset(
                        'assets/images/ico_daily_benefit_locked.svg',
                        width: 50.sp,
                        height: 50.sp,
                      )
                    : widget.benefitItem.imageUrl!.contains('.svg')
                        ? SvgPicture.network(
                            widget.benefitItem.imageUrl!,
                            fit: BoxFit.fitHeight,
                            width: 50.sp,
                            height: 50.sp,
                            placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                            headers: imageNetworkHeader,
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.benefitItem.imageUrl!,
                            height: 50.sp,
                            width: 50.sp,
                            placeholder: (context, string) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                            httpHeaders: imageNetworkHeader,
                          ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FittedBox(
                    child: widget.benefitItem.distance == 0
                        ? const StyledText(
                            '출석체크',
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            lineHeight: 18,
                            fontWeight: 500,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                widget.benefitItem.distance >= 1000 ? formatMeterToKilometer(widget.benefitItem.distance.toInt()) : formatDecimalPlaces(widget.benefitItem.distance, 0),
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                lineHeight: 18,
                                fontWeight: 500,
                                letterSpacing: -0.3,
                                color: widget.userDistance < widget.benefitItem.distance ? deepGrayColor : Colors.white,
                              ),
                              StyledText(
                                widget.benefitItem.distance >= 1000 ? 'km' : 'm',
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                lineHeight: 18,
                                fontWeight: 400,
                                color: widget.userDistance < widget.benefitItem.distance ? deepGrayColor : Colors.white,
                              ),
                            ],
                          ),
                  ),
                ),
                Material(
                  clipBehavior: Clip.none,
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: widget.benefitItem.received || widget.userDistance < widget.benefitItem.distance ? subBg01Color : skyBlueColor,
                        border: Border.all(
                          color: widget.benefitItem.received || widget.userDistance < widget.benefitItem.distance ? deepGrayColor : Colors.black,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: widget.benefitItem.received || widget.userDistance < widget.benefitItem.distance
                            ? null
                            : () async {
                                if (widget.locked) {
                                  showToastPopup('혜택은 순서대로 받을 수 있어요.');
                                  return;
                                }
                                if (_loading) {
                                  return;
                                }
                                toggleLoadingState();
                                await controller.requestBenefit(widget.benefitItem);
                                toggleLoadingState();
                              },
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: StyledText(
                              widget.benefitItem.received ? widget.benefitItem.labelReceived : widget.benefitItem.label,
                              fontSize: 10,
                              lineHeight: 10,
                              fontWeight: 600,
                              letterSpacing: -0.03,
                              textAlign: TextAlign.center,
                              color: widget.userDistance < widget.benefitItem.distance
                                  ? deepGrayColor
                                  : widget.benefitItem.received
                                      ? skyBlueColor
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_loading)
            Positioned.fill(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
