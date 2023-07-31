import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryTile extends StatelessWidget {
  const InventoryTile({
    Key? key,
    this.id,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    this.durability,
    this.itemGrade,
    this.badgeId,
  }) : super(key: key);

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
      child: InkWell(
        onTap: () {
          if (badgeId != null && badgeId != -1) {
            controller.toBadgeDetail(badgeId!);
          } else {
            controller.toItemDetail(id!);
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
                padding: badgeId != null && badgeId != -1 ? EdgeInsets.only(top: 10.0.sp, bottom: 30.sp, left: 35.sp, right: 35.sp) : EdgeInsets.all(index < 1 ? 20.sp : 10.0.sp),
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
                                  placeholderBuilder: (BuildContext context) => Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator(),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                  errorWidget: (context, url, error) => iconNoBadge,
                                  fit: BoxFit.contain,
                                  httpHeaders: imageNetworkHeader,
                                )
                          : iconNoBadge,
                    ),
                  ],
                ),
              ),
              if (badgeId != null && badgeId != -1)
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.sp,
                      horizontal: 10.sp,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.sp),
                      border: Border.all(
                        width: 1,
                        color: deepGrayColor,
                      ),
                    ),
                    child: StyledText(
                      '#${badgeId.toString()}',
                      fontSize: 10,
                      lineHeight: 10,
                      fontWeight: 500,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                      color: deepGrayColor,
                    ),
                  ),
                ),
              durability != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 9.0.sp),
                      child: SizedBox(
                        height: 22.sp,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    child: SizedBox(
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(2.0.sp),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF606167),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.sp),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    offset: Offset(0, 1.sp),
                                                    blurRadius: 0.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          durability! > 1.0
                                              ? Padding(
                                                  padding: EdgeInsets.only(top: 2.0.sp, left: 2.0.sp),
                                                  child: LayoutBuilder(builder: (context, constraints) {
                                                    return Container(
                                                      height: 18.sp,
                                                      margin: EdgeInsets.zero,
                                                      width: durability! > 20
                                                          ? constraints.maxWidth / (100 / durability!)
                                                          : durability! < 2
                                                              ? 0
                                                              : 34,
                                                      decoration: BoxDecoration(
                                                        color: durability! < 30 ? textRedColor : purpleColor,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(50.sp),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                )
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
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                                      child: iconShoes,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              right: -1,
                              top: -1,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.0.sp),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 1.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.sp),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 1.sp),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () => controller.showShoesRepairPopup(id!, context),
                                    child: CircleAvatar(
                                      radius: 10.sp,
                                      backgroundColor: purpleColor,
                                      child: IconButton(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                        iconSize: 20.0.sp,
                                        icon: iconPlus,
                                        onPressed: null,
                                        // onPressed: () => {controller.onClickRepairStat(stat)},
                                      ),
                                    ),
                                  ),
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
    Key? key,
  }) : super(key: key);

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
