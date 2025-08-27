import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class NameBadgeSection extends GetWidget<ArchiveController> {
  const NameBadgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.sp).copyWith(
        top: 8.sp,
        bottom: 12.sp,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              controller.getArchiveTypeImage(controller.selectedItem.value),
              if (controller.selectedItem.value.badgeIssueId != null)
                controller.selectedItem.value.badgeImageUrl!.contains('.svg')
                    ? Positioned(
                        right: 0,
                        bottom: 2,
                        child: SvgPicture.network(
                          width: 20.sp,
                          height: 20.sp,
                          fit: BoxFit.contain,
                          controller.selectedItem.value.badgeImageUrl!,
                          headers: imageNetworkHeader,
                        ),
                      )
                    : Positioned(
                        right: 0,
                        bottom: 2,
                        child: CachedNetworkImage(
                          width: 20.sp,
                          height: 20.sp,
                          imageUrl:
                              controller.selectedItem.value.badgeImageUrl!,
                          fit: BoxFit.fitHeight,
                          httpHeaders: imageNetworkHeader,
                        ),
                      ),
            ],
          ),
          SizedBox(width: 8.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDateUntilDay(controller.selectedItem.value.startedDate),
                style: AppTextStyleData.regular().koBodySemiboldLg.copyWith(
                      color: AppColorData.regular().colorTextSecondary,
                    ),
              ),
              if (controller.selectedItem.value.secondName != null)
                Text(
                  controller.selectedItem.value.secondName!,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
