import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryBadge extends StatelessWidget {
  const InventoryBadge({Key? key}) : super(key: key);

  List<Widget> renderUserBadgesList(InventoryController controller) {
    return controller.userBadgesList
        .map(
          (item) => InkWell(
            onTap: () => controller.toBadgeDetail(item.badgeId),
            child: Container(
              decoration: BoxDecoration(
                color: subBg01Color,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.0.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: item.state == 'EQUIPPED' ? 0.5 : 1,
                      child: Container(
                        height: 105.sp,
                        padding: EdgeInsets.all(10.0.sp),
                        child: item.imageUrl!.contains('.svg')
                            ? SvgPicture.network(
                                fit: BoxFit.fitWidth,
                                item.imageUrl!,
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(20.0), child: const CircularProgressIndicator()),
                              )
                            : CachedNetworkImage(
                                imageUrl: item.imageUrl!,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                      ),
                    ),
                    // if (item.name != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //     child: StyledText(item.name!),
                    //   ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0.sp),
                      child: item.state == 'EQUIPPED'
                          ? InkWell(
                              onTap: () => null,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: popupBgColor,
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: deepGrayColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.sp),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3.sp),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: StyledText(
                                    '장착중',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    color: deepGrayColor,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => controller.fetchEquipBadge(item.badgeId),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: popupBgColor,
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: const Color(0xFF54F5FF),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.sp),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3.sp),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: const StyledText(
                                    '장착',
                                    fontWeight: 500,
                                    fontSize: 14,
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
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: popupBgColor,
      child: controller.userBadgesList.isEmpty
          ? Container(
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
                      '뱃지가 없습니다.',
                      color: Color(0xff7b7b7b),
                      fontSize: 16,
                      lineHeight: 10,
                      fontWeight: 500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 13.sp),
                    child: const StyledText(
                      '등산해서 뱃지를 받아보세요!',
                      color: Color(0xff7b7b7b),
                      fontSize: 16,
                      lineHeight: 10,
                      fontWeight: 500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
              child: Obx(() {
                return GridView.count(
                  primary: false,
                  padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 30.sp),
                  childAspectRatio: (1 / 1.4),
                  crossAxisSpacing: 10.sp,
                  mainAxisSpacing: 10.sp,
                  crossAxisCount: (width < 350.sp) ? 2 : 3,
                  controller: controller.badgeScrollController,
                  children: <Widget>[
                    ...renderUserBadgesList(controller),
                  ],
                );
              }),
            ),
    );
  }
}
