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
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({super.key});


  List<Widget> renderItemSubTabList(InventoryHomeController controller) {
    return controller.itemSubTabList
        .map(
          (item) => Padding(
            padding: EdgeInsets.only(left: 12.0.sp, right: 12.0.sp, top: 6.0.sp, bottom: 3.0.sp),
            child: Text(item['title']!),
          ),
        )
        .toList();
  }

  List<Widget> renderItemList(InventoryHomeController homeController, InventoryController controller, BuildContext context) {
    return homeController.itemSubTabList
        .map(
          (tab) => Padding(
            padding: EdgeInsets.only(left: 12.0.sp, right: 12.sp),
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              children: [
                ...controller.allItems[tab['itemType']]!.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(left: 4.0.sp, right: 4.sp, top: 4.sp, bottom: 4.sp),
                    child: InkWell(
                      onTap: () => controller.toItemDetail(item.id),
                      child: Container(
                        width: MediaQuery.of(context).size.width > 450 ? (MediaQuery
                            .of(context)
                            .size
                            .width / 6) - 16.sp : (MediaQuery
                            .of(context)
                            .size
                            .width / 3) - 16.sp,
                        decoration: BoxDecoration(
                          color: subBg01Color,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.sp),
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (item.publishType == 'NFT') Positioned(right: 8.sp, top: 8.sp, child: SvgPicture.asset('assets/images/inventory/ico_nft.svg')),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 18.0.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60.sp,
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
                                        ? Text(
                                            item.itemName,
                                            style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                              color: AppColorData.regular().colorTextInteractiveSecondaryDisabled
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            item.itemName,
                                            style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                              color: AppColorData.regular().colorTextPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
                                              color: Colors.transparent,
                                              border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color: AppColorData.regular().colorBorderInteractivePrimary,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25.sp),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                              child: Text(
                                                item.itemCategory == 'DISPOSABLE' ? '사용하기' : '장착하기',
                                                style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                                      color: AppColorData.regular().colorTextPrimary,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              width: 1,
                                              style: BorderStyle.solid,
                                              color: AppColorData.regular().colorBorderInteractivePrimaryPressed,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.sp),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                            child: Text(
                                              '장착 중',
                                              style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                                    color: AppColorData.regular().colorTextInteractivePrimaryPressed,
                                                  ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            if (item.itemCategory == 'DISPOSABLE' && item.amount != null)
                              Positioned(
                                left: 8.sp,
                                top: 8.sp,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColorData.regular().colorBaseBalck,
                                    borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius4.sp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 6.0.sp),
                                    child: Text(
                                      item.amount! > 99 ? '99+' : item.amount.toString(),
                                      style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                        color: AppColorData.regular().colorBaseWhite,
                                      ),
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
                                Positioned(
                                  left: 8.sp,
                                  top: 56.sp,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.sp,
                                      vertical: 1.sp,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller.getRemainingDays(item.expiredDate!) == 0 ? AppColorData.regular().colorBgWarningSubtle  : AppColorData.regular().colorPointBrandgray,
                                      borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius4.sp),
                                    ),
                                    child: Text(
                                        'D-${controller.getRemainingDays(item.expiredDate!)}',
                                            style: AppTextStyleData.regular().koCaptionSemiboldMd.copyWith(
                                              color: AppColorData.regular().colorTextInverse,
                                            ),
                                    ),
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
                ),
              ],
            ),
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
            child: TabBar(
              padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
              controller: controller.subTabController,
              isScrollable: true,
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, height: 1),
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.black,
              unselectedLabelColor: const Color(0xFF898B92),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(80.0.sp),
                color: const Color(0xFFECECEC),
              ),
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: [...renderItemSubTabList(controller)],
              onTap: (index) => inventoryController.getUserItemsByCategory(controller.itemSubTabList, index),
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
                    ...renderItemList(controller, inventoryController, context),
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
