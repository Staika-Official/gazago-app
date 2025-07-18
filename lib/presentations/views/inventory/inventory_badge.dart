import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class InventoryBadge extends StatelessWidget {
  const InventoryBadge({super.key});

  List<Widget> renderUserBadgesList(
      InventoryController controller, BuildContext context) {
    return controller.userBadgesList
        .map(
          (item) => InkWell(
            onTap: () => controller.toBadgeDetail(item.badgeId),
            child: Container(
              width: MediaQuery.of(context).size.width > 450
                  ? ((MediaQuery.of(context).size.width - 32 - 40) / 6)
                      .floorToDouble()
                  : ((MediaQuery.of(context).size.width - 32 - 16) / 3)
                      .floorToDouble(),
              decoration: BoxDecoration(
                color: subBg01Color,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10.0.sp, horizontal: 18.0.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: item.state == 'EQUIPPED' ? 0.5 : 1,
                      child: SizedBox(
                        height: 68.sp,
                        // padding: EdgeInsets.all(10.0.sp),
                        child: item.imageUrl!.contains('.svg')
                            ? SvgPicture.network(
                                fit: BoxFit.contain,
                                item.imageUrl!,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: const CircularProgressIndicator(
                                            color: skyBlueColor)),
                                headers: imageNetworkHeader,
                              )
                            : CachedNetworkImage(
                                imageUrl: item.imageUrl!,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(
                                    child: SizedBox.square(
                                        dimension: 40,
                                        child: CircularProgressIndicator(
                                            color: skyBlueColor))),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        "assets/images/@temp_badge.png"),
                                httpHeaders: imageNetworkHeader,
                              ),
                      ),
                    ),
                    // if (item.name != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //     child: StyledText(item.name!),
                    //   ),
                    if (item.name != null)
                      Text(
                        item.name!,
                        style: AppTextStyleData.regular()
                            .koBodyMediumSm
                            .copyWith(
                                color: AppColorData.regular().colorTextPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.0.sp),
                      child: item.state == 'EQUIPPED'
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: AppColorData.regular()
                                      .colorBorderInteractivePrimaryPressed,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.sp),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text(
                                  'equipped'.tr(),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumSm
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorTextInteractivePrimaryPressed,
                                      ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () =>
                                  controller.fetchEquipBadge(item.badgeId),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: AppColorData.regular()
                                        .colorBorderInteractivePrimary,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.sp),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  child: Text(
                                    'equip_item'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koBodyMediumSm
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorTextPrimary,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                    ),
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
    InventoryController controller = Get.put(InventoryController());

    return Obx(() {
      return Container(
        color: popupBgColor,
        child: controller.userBadgesList.isEmpty
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 60.sp),
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
                      child: Text('no_badges'.tr(),
                          style: AppTextStyleData.regular()
                              .koHeadingMediumSm
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.sp),
                      child: Text('get_badges_by_hiking'.tr(),
                          style: AppTextStyleData.regular()
                              .koBodyMediumLg
                              .copyWith(
                                color:
                                    AppColorData.regular().colorTextSecondary,
                              )),
                    ),
                  ],
                ),
              )
            : Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 16.0),
                child: Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      ...renderUserBadgesList(controller, context),
                    ],
                  );
                }),
              ),
      );
    });
  }
}
