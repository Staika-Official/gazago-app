import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class ArchiveHome extends StatelessWidget {
  const ArchiveHome({super.key});

  List<Widget> renderArchiveList(ArchiveController controller) {
    return controller.archiveList
        .map(
          (archive) => InkWell(
            onTap: () => controller.dataGetLoading.value ? null : controller.toDetail(archive.id!),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.sp),
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgTertiary,
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 4.sp), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                color: AppColorData.regular().colorBgTertiary,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0.sp, left: 20.0.sp, right: 20.0.sp, bottom: 12.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              controller.getArchiveTypeImage(archive),
                              if (archive.badgeIssueId != null)
                                archive.badgeImageUrl!.contains('.svg')
                                    ? Positioned(
                                        right: 0,
                                        bottom: 2,
                                        child: SvgPicture.network(
                                          width: 20.sp,
                                          height: 20.sp,
                                          fit: BoxFit.contain,
                                          archive.badgeImageUrl!,
                                          headers: imageNetworkHeader,
                                        ),
                                      )
                                    : Positioned(
                                        right: 0,
                                        bottom: 2,
                                        child: CachedNetworkImage(
                                          width: 20.sp,
                                          height: 20.sp,
                                          imageUrl: archive.badgeImageUrl!,
                                          fit: BoxFit.fitHeight,
                                          httpHeaders: imageNetworkHeader,
                                        ),
                                      ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.sp,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    formatDateUntilDay(archive.startedDate!),
                                    style: AppTextStyleData.regular().koBodySemiboldLg.copyWith(
                                      color: AppColorData.regular().colorTextPrimary
                                    ),
                                ),
                                if (archive.challengeTitle != null)
                                  Text(
                                      archive.challengeTitle!,
                                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                        color: AppColorData.regular().colorTextSecondary
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: AppColorData.regular().colorBorderPrimary,
                        height: 22.sp,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 4.sp),
                                  child: iconArchiveClock,
                                ),
                                Text(
                                  formatSeconds(archive.time!),
                                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                      color: AppColorData.regular().colorTextInteractivePrimary,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 4.sp),
                                child: iconArchiveDistance,
                              ),
                              Text(
                                '${formatDecimalPlaces(convertMetersToKm(archive.rewardDistance!), 3, isAutoDecimal: true)} km',
                                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                  color: AppColorData.regular().colorTextInteractivePrimary,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 4.sp),
                                  child: iconArchiveSteps,
                                ),
                                Text(
                                  '${archive.steps}',
                                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                    color: AppColorData.regular().colorTextInteractivePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.put(ArchiveController());

    return Container(
      color: subBg01Color,
      child: Obx(() {
        return Padding(
          padding: EdgeInsets.only(top: 0.sp, left: 20.sp, right: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     icon: Icon(Icons.sort),
              //     onPressed: null,
              //   ),
              // ),

              controller.archiveList.isEmpty
                  ? controller.dataGetLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                          child: const Center(child: CircularProgressIndicator(color:skyBlueColor)),
                        )
                      : Padding(
                        padding: EdgeInsets.only(top:20.0.sp),
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 50.sp),
                            decoration: BoxDecoration(
                              color: popupBgColor,
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                iconEmpty,
                                Padding(
                                  padding: EdgeInsets.only(top: 20.sp),
                                  child: const StyledText(
                                    '운동 기록이 없습니다.',
                                    color: Color(0xff7b7b7b),
                                    fontSize: 16,
                                    lineHeight: 10,
                                    fontWeight: 500,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 13.sp),
                                  child: const StyledText(
                                    '운동하고 GO를 쌓아보세요!',
                                    color: Color(0xff7b7b7b),
                                    fontSize: 16,
                                    lineHeight: 10,
                                    fontWeight: 500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      )
                  : Expanded(
                      child: SingleChildScrollView(
                        controller: controller.scroll,
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...renderArchiveList(controller),
                              if (controller.dataGetLoading.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                                  child: const Center(child: CircularProgressIndicator(color:skyBlueColor)),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
