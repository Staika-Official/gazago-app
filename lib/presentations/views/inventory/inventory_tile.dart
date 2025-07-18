import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class InventoryTile extends StatelessWidget {
  const InventoryTile({
    super.key,
    this.id,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    this.durability,
    this.itemGrade,
    this.badgeId,
  });

  final int index;
  final int? id;
  final double? durability;
  final String imageUrl;
  final String? itemGrade;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final int? badgeId;

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.find();

    final child = Container(
      color: Colors.transparent,
      height: extent,
      child: GestureDetector(
        onTap: () {
          if (badgeId != null && badgeId != -1) {
            controller.toBadgeDetail(badgeId!);
          } else {
            if (id != null) controller.toItemDetail(id!);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: popupBgColor,
            border: Border.all(
              width: 2.sp,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(14.sp),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2.sp, 4.sp),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: badgeId != null && badgeId != -1
                    ? EdgeInsets.only(
                        top: 10.0.sp, bottom: 30.sp, left: 35.sp, right: 35.sp)
                    : EdgeInsets.all(index < 1 ? 20.sp : 10.0.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: index == 1 ? 1 / 1 : 1.2 / 1,
                      child: imageUrl != ''
                          ? imageUrl.contains('.svg')
                              ? SvgPicture.network(
                                  fit: BoxFit.contain,
                                  imageUrl,
                                  placeholderBuilder: (BuildContext context) =>
                                      const Center(
                                          child: SizedBox.square(
                                              dimension: 40,
                                              child: CircularProgressIndicator(
                                                  color: skyBlueColor))),
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => const Center(
                                      child: SizedBox.square(
                                          dimension: 40,
                                          child: CircularProgressIndicator(
                                              color: skyBlueColor))),
                                  errorWidget: (context, url, error) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        iconNoBadge,
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.sp),
                                                child: Text(
                                                  'No Badges',
                                                  style: AppTextStyleData
                                                          .regular()
                                                      .numBodySemiboldSm
                                                      .copyWith(
                                                          color: AppColorData
                                                                  .regular()
                                                              .colorTextTertiary),
                                                )))
                                      ]),
                                  fit: BoxFit.contain,
                                  httpHeaders: imageNetworkHeader,
                                )
                          : Stack(alignment: Alignment.center, children: [
                              iconNoBadge,
                              Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 10.sp),
                                      child: Text(
                                        'No Badges',
                                        style: AppTextStyleData.regular()
                                            .numBodySemiboldSm
                                            .copyWith(
                                                color: AppColorData.regular()
                                                    .colorTextTertiary),
                                      )))
                            ]),
                    ),
                  ],
                ),
              ),
              if (badgeId != null && badgeId != -1)
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.sp),
                      border: Border.all(
                        width: 1,
                        color: AppColorData.regular().colorBorderTertiary,
                      ),
                    ),
                    child: Text(
                      '#${badgeId.toString()}',
                      style:
                          AppTextStyleData.regular().numBodySemiboldMd.copyWith(
                                color: AppColorData.regular().colorTextTertiary,
                              ),
                    ),
                  ),
                ),
              durability != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0.sp, vertical: 9.0.sp),
                      child: SizedBox(
                        height: 28.sp,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(2.0.sp),
                                          child: Container(
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFF2E3038),
                                              shape: RoundedRectangleBorder(
                                                side:
                                                    const BorderSide(width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              shadows: [
                                                const BoxShadow(
                                                  color: Color(0xFF000000),
                                                  blurRadius: 0,
                                                  offset: Offset(0, 4),
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        durability! > 1.0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2.0.sp, left: 2.0.sp),
                                                child: LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  return Container(
                                                    height: 28.sp,
                                                    margin: EdgeInsets.zero,
                                                    width: durability! > 20
                                                        ? constraints.maxWidth /
                                                            (100 / durability!)
                                                        : durability! < 2
                                                            ? 0
                                                            : 34,
                                                    decoration: ShapeDecoration(
                                                      color: durability! < 30
                                                          ? textRedColor
                                                          : AppColorData
                                                                  .regular()
                                                              .colorPointPurple,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(999),
                                                      ),
                                                      shadows: [
                                                        const BoxShadow(
                                                          color:
                                                              Color(0xFF000000),
                                                          blurRadius: 0,
                                                          offset: Offset(0, 2),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              top: 2,
                              child: InkWell(
                                onTap: () => controller.isDisableButton.value
                                    ? null
                                    : controller.showShoesRepairPopup(
                                        id!, context),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  padding: const EdgeInsets.all(2),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFB85DFF),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    shadows: [
                                      const BoxShadow(
                                        color: Color(0xFF000000),
                                        blurRadius: 0,
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: iconPlusThin,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              itemGrade != null
                  ? Positioned(
                      right: index > 1 ? 6.sp : 10.sp,
                      top: index > 1 ? 6.sp : 10.sp,
                      child: getItemGradeCircleIcon(itemGrade!),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
      ],
    );
  }
}

class InventoryTilePlaceHolder extends StatelessWidget {
  const InventoryTilePlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          border: Border.all(
            width: 2.sp,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(14.sp),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2.sp, 4.sp),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Expanded(child: child),
      ],
    );
  }
}
