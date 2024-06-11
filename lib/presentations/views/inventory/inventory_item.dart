import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({Key? key}) : super(key: key);

  List<Widget> renderItemSubTabList(InventoryHomeController controller) {
    return controller.itemSubTabList
        .map(
          (item) => Text(item['title']!),
        )
        .toList();
  }

  List<Widget> renderItemList(InventoryHomeController homeController, InventoryController controller, double width) {
    return homeController.itemSubTabList
        .map(
          (tab) => GridView.count(
            primary: false,
            padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
            childAspectRatio: (1 / 1.4),
            crossAxisSpacing: 10.sp,
            mainAxisSpacing: 10.sp,
            crossAxisCount: (width < 350)
                ? 2
                : (width > 450)
                    ? 6
                    : 3,
            cacheExtent: 1000,
            children: [
              ...controller.allItems[tab['itemType']]!.map(
                (item) => InkWell(
                  onTap: () => controller.toItemDetail(item.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: subBg01Color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.sp),
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (item.itemPublishType == 'NFT') Positioned(right: 8.sp, top: 8.sp, child: SvgPicture.asset('assets/images/inventory/ico_nft.svg')),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.0.sp, horizontal: 15.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 80.sp,
                                child: controller.isConsumerItemUsing.value != null && controller.isConsumerItemUsing.value.id == item.id
                                    ? const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator()))
                                    : Container(
                                        child: item.itemImageUrl.contains('.svg')
                                            ? SvgPicture.network(
                                                fit: BoxFit.fitHeight,
                                                item.itemImageUrl,
                                                placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                headers: imageNetworkHeader,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: item.itemImageUrl,
                                                fit: BoxFit.fitHeight,
                                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                                                httpHeaders: imageNetworkHeader,
                                                color: item.equipped == true ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(1),
                                                colorBlendMode: BlendMode.modulate,
                                              ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.sp, bottom: 6.sp),
                                child: item.equipped == true
                                    ? StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: lightGrayColor.withOpacity(0.5),
                                        overflowEllipsis: true,
                                      )
                                    : StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: lightGrayColor,
                                        overflowEllipsis: true,
                                      ),
                              ),
                              item.equipped == false
                                  ? InkWell(
                                      onTap: () => item.itemCategory == 'DISPOSABLE'
                                          ? controller.isConsumerItemUsing.value == null
                                              ? controller.checkConsumerItemType(item)
                                              : null
                                          : controller.checkEquippedInventoryChallengeItem(item.id, item.itemCategory),
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
                                          child: StyledText(
                                            item.itemCategory == 'DISPOSABLE' ? '사용하기' : '장착',
                                            fontWeight: 500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
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
                                        child: StyledText('장착중', fontWeight: 500, fontSize: 14, color: deepGrayColor),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        if (item.itemCategory == 'DISPOSABLE' && item.amount! > 1)
                          Positioned(
                            left: 8.sp,
                            top: 8.sp,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF0E0E13),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 6.0.sp),
                                child: StyledText(
                                  item.amount != null ? item.amount.toString() : '0',
                                  fontSize: 12,
                                  lineHeight: 12,
                                  letterSpacing: -.1,
                                  fontWeight: 600,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 8.sp,
                          top: 8.sp,
                          width: 18,
                          height: 18,
                          child: getItemGradeCircleIcon(item.itemGrade),
                        ),
                        if (item.expiredDate != null)
                          if (controller.getRemainingDays(item.expiredDate!) < 3)
                            Positioned(
                              left: 7.sp,
                              top: 70.sp,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7.sp,
                                  vertical: 5.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.getRemainingDays(item.expiredDate!) == 0 ? const Color(0xffFD5D70) : popupBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: StyledText('D-${controller.getRemainingDays(item.expiredDate!)}'),
                              ),
                            ),
                        // Positioned(
                        //   right: 7.sp,
                        //   top: 7.sp,
                        //   width: 18,
                        //   height: 18,
                        //   child: getItemGradeCircleIcon(item.itemGrade),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryHomeController controller = Get.find();
    InventoryController inventoryController = Get.find();
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: popupBgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.sp),
            child: SizedBox(
              height: 28.sp,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                  controller: controller.subTabController,
                  isScrollable: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF898B92),
                  labelPadding: EdgeInsets.only(left: 12.0.sp, right: 12.0.sp, top: 6.0.sp, bottom: 3.0.sp),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0.sp),
                    color: const Color(0xFFECECEC),
                  ),
                  tabs: [...renderItemSubTabList(controller)],
                  onTap: (index) => inventoryController.getUserItemsByCategory(controller.itemSubTabList, index),
                ),
              ),
            ),
          ),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 5.0.sp),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.subTabController,
                  children: [
                    ...renderItemList(controller, inventoryController, width),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
