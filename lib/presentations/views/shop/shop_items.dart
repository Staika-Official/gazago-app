import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ShopItems extends StatelessWidget {
  const ShopItems({Key? key}) : super(key: key);

  List<Widget> renderShopItemsList(BuildContext context, ShopController shopController) {
    return shopController.shopItemsList
        .map(
          (item) => InkWell(
            onTap: () => shopController.toItemDetail(item.id),
            child: Container(
              decoration: BoxDecoration(
                color: subBg01Color,
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.sp),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: getItemGradeIcon(item.itemGrade),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0.sp),
                              child: item.itemImageUrl != null
                                  ? AspectRatio(
                                      // child: Image.network(
                                      //   "http://via.placeholder.com/350x150",
                                      // ),
                                      aspectRatio: 1.5,
                                      child: CachedNetworkImage(
                                        imageUrl: item.itemImageUrl!,
                                        fit: BoxFit.fitHeight,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Image.asset("assets/images/@temp_bal.png"),
                                      ),
                                    )
                                  : Container(),
                            ),
                            StyledText(
                              item.name,
                              fontSize: 14,
                              fontWeight: 500,
                              color: lightGrayColor,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 7,
                                            backgroundColor: skyBlueColor,
                                            child: iconShopReward,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 3.0.sp),
                                            child: StyledText(
                                              '${formatDecimalPlaces(item.fromRewardRate, 0)}-${formatDecimalPlaces(item.toRewardRate, 0)}',
                                              fontSize: 12,
                                              fontWeight: 600,
                                              color: skyBlueColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    item.itemCategory == 'SHOES'
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 7,
                                                  backgroundColor: purpleColor,
                                                  child: iconShopDurability,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 3.0.sp),
                                                  child: StyledText(
                                                    '${formatDecimalPlaces(item.fromAbrasionRate, 0)}-${formatDecimalPlaces(item.toAbrasionRate, 0)}',
                                                    fontSize: 12,
                                                    fontWeight: 600,
                                                    color: purpleColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 7,
                                            backgroundColor: lightGreenColor,
                                            child: iconShopStamina,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 3.0.sp),
                                            child: StyledText(
                                              '${formatDecimalPlaces(item.fromStaminaReduceRate, 0)}-${formatDecimalPlaces(item.toStaminaReduceRate, 0)}',
                                              fontSize: 12,
                                              fontWeight: 600,
                                              color: lightGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    left: 0,
                    bottom: 0,
                    top: null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12.sp),
                          bottomLeft: Radius.circular(12.sp),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0.sp, horizontal: 12.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            item.itemLabel != null
                                ? StyledText(
                                    '마감임박',
                                    fontSize: 12.sp,
                                    fontWeight: 600,
                                    color: skyBlueColor,
                                  )
                                : Container(),
                            StyledText(
                              '${formatDecimalPlaces(item.price.toDouble(), 0)} TIK',
                              fontSize: 14.sp,
                              fontWeight: 700,
                              letterSpacing: .3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ShopController shopController = Get.find();
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0.sp, left: 20.sp, right: 20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => shopController.showItemSortingPopup(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(1, 0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0.sp, top: 11.sp, bottom: 11.sp, right: 58.sp),
                            child: StyledText(
                              shopController.isSelectedSortString.value,
                              fontWeight: 500,
                              fontSize: 14,
                            ),
                          ),
                          Positioned(
                            right: 15.sp,
                            top: 14.sp,
                            child: iconArrowDown,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (shopController.isSelectAllItems.value)
                        Padding(
                          padding: EdgeInsets.only(right: 10.0.sp),
                          child: StyledText(
                            '전체',
                            fontWeight: 600,
                            fontSize: 14,
                            lineHeight: 22,
                            color: lightGrayColor,
                          ),
                        ),
                      InkWell(
                        onTap: () => shopController.showItemFilterPopup(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: popupBgColor,
                            border: Border.all(
                              width: 1.sp,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.sp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2.sp, 2.sp),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
                            child: shopController.isSelectAllItems.value ? iconShopFilter : iconShopFilterActive,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              shopController.shopItemsList.isEmpty
                  ? shopController.dataGetLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 120.0.sp),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 120.sp),
                          decoration: BoxDecoration(
                            color: popupBgColor,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconShopEmpty,
                              Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: StyledText(
                                  '필터결과를 찾을 수 없습니다.',
                                  color: lightGrayColor,
                                  fontSize: 16,
                                  lineHeight: 18,
                                  fontWeight: 500,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50.0.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            runSpacing: 10.0,
                                            spacing: 10.0,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            children: [
                                              ...shopController.filteredCategory.asMap().entries.map(
                                                    (entry) => Container(
                                                      decoration: BoxDecoration(
                                                        color: popupBgColor,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                        borderRadius: BorderRadius.circular(20.sp),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                                                        child: StyledText(
                                                          shopController.categoryFilterList.firstWhere((element) => element['value'] == entry.value)['title']!,
                                                          fontSize: 14,
                                                          lineHeight: 16,
                                                          letterSpacing: .2,
                                                          fontWeight: 500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.0.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            runSpacing: 10.0,
                                            spacing: 10.0,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            children: [
                                              ...shopController.filteredGrade.asMap().entries.map(
                                                    (entry) => Container(
                                                      decoration: BoxDecoration(
                                                        color: popupBgColor,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: getItemGradeColor(entry.value),
                                                        ),
                                                        borderRadius: BorderRadius.circular(20.sp),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                                                        child: StyledText(
                                                          entry.value!,
                                                          fontSize: 14,
                                                          lineHeight: 16,
                                                          letterSpacing: .2,
                                                          fontWeight: 500,
                                                          color: getItemGradeColor(entry.value),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                        child: Obx(() {
                          return GridView.count(
                            primary: false,
                            padding: EdgeInsets.only(bottom: 30.sp),
                            childAspectRatio: (1 / 1.4),
                            crossAxisSpacing: 14.sp,
                            mainAxisSpacing: 14.sp,
                            crossAxisCount: 2,
                            // controller: controller.badgeScrollController,
                            children: <Widget>[
                              ...renderShopItemsList(context, shopController),
                            ],
                          );
                        }),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
