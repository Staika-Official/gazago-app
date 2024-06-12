import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class ShopItems extends StatelessWidget {
  const ShopItems({Key? key}) : super(key: key);

  List<Widget> renderItemTabList(ShopController controller) {
    return controller.categoryFilterList
        .map(
          (item) => Text(item['title']!),
        )
        .toList();
  }

  List<Widget> renderShopItemsList(BuildContext context, ShopController shopController) {
    return shopController.shopItemsList
        .map(
          (item) => InkWell(
            onTap: () => shopController.toItemDetail(item.id),
            child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgTertiary,
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
                  if (item.publishType == 'NFT') Positioned(right: 10.sp, top: 10.sp, child: SvgPicture.asset('assets/images/shop/ico_nft.svg')),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: item.itemGrade != 'NONE'
                            ? getItemGradeIcon(item.itemGrade)
                            : const SizedBox(
                                width: 90,
                                height: 24,
                              ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.sp, bottom: 6.sp),
                            child: item.itemImageUrl != null
                                ? AspectRatio(
                                    aspectRatio: 1.9,
                                    child: item.itemImageUrl!.contains('.svg')
                                        ? SvgPicture.network(
                                            fit: BoxFit.contain,
                                            item.itemImageUrl!,
                                            placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                            headers: imageNetworkHeader,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: item.itemImageUrl!,
                                            fit: BoxFit.fitHeight,
                                            placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                            errorWidget: (context, url, error) => Image.asset("assets/images/@temp_bal.png"),
                                            httpHeaders: imageNetworkHeader,
                                          ),
                                  )
                                : Container(),
                          ),
                          Text(
                            item.name,
                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                  color: AppColorData.regular().colorTextSecondary,
                                ),
                          ),
                          if (item.maxGoProfit != 0 || item.maxDurability != 0 || item.maxStamina != 0 || item.maxLuck != 0 || item.recoveryStamina != 0 || item.repairDurability != 0)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (item.maxGoProfit! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopReward,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '${formatDecimalPlaces(item.minGoProfit!, 0)}-${formatDecimalPlaces(item.maxGoProfit!, 0)}',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                letterSpacing: -.1,
                                                color: skyBlueColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (item.maxDurability! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopDurabilityLight,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '${formatDecimalPlaces(item.minDurability!, 0)}-${formatDecimalPlaces(item.maxDurability!, 0)}',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                letterSpacing: -.1,
                                                color: AppColorData.regular().colorPointPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (item.maxStamina! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopStamina,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '${formatDecimalPlaces(item.minStamina!, 0)}-${formatDecimalPlaces(item.maxStamina!, 0)}',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                letterSpacing: -.1,
                                                color: lightGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (item.maxLuck! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopLuck,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '${formatDecimalPlaces(item.minLuck!, 0)}-${formatDecimalPlaces(item.maxLuck!, 0)}',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                color: pinkColor,
                                                letterSpacing: -.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (item.recoveryStamina! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopStamina,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '+${formatDecimalPlaces(item.recoveryStamina!, 0)} 회복',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                color: lightGreenColor,
                                                letterSpacing: -.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (item.repairDurability! > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12.sp,
                                              height: 12.sp,
                                              child: iconShopDurabilityLight,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: StyledText(
                                                '+${formatDecimalPlaces(item.repairDurability!, 0)} 수리',
                                                fontSize: 12,
                                                fontWeight: 600,
                                                color: AppColorData.regular().colorPointPurple,
                                                letterSpacing: -.1,
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
                  Positioned.fill(
                    left: 0,
                    bottom: 0,
                    top: null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff222229),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12.sp),
                          bottomLeft: Radius.circular(12.sp),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0.sp, horizontal: 12.sp),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              item.itemLabel != null
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 5.0.sp),
                                      child: Text(
                                        item.itemLabel! == 'CLOSE_DEADLINE' ? '마감임박' : '품절',
                                        style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                              color: AppColorData.regular().colorTextBrand,
                                            ),
                                      ),
                                    )
                                  : Container(),
                              Text(
                                '${formatDecimalPlaces(item.price.toDouble(), item.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ${item.tradeSymbol}',
                                style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                                      color: AppColorData.regular().colorTextPrimary,
                                    ),
                              ),
                            ],
                          ),
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
    ShopController shopController = Get.put(ShopController());
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: 35.sp,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                controller: shopController.tabController,
                isScrollable: true,
                labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF898B92),
                labelPadding: EdgeInsets.only(left: 12.0.sp, right: 12.0.sp, top: 0.0.sp, bottom: 14.0.sp),
                indicator: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: skyBlueColor,
                    width: 2,
                  )),
                ),
                tabs: [...renderItemTabList(shopController)],
                onTap: (index) => shopController.onSelectCategory(shopController.categoryFilterList[index]['value']),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
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
                                child: const StyledText(
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
                                      child: const StyledText(
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
                              padding: EdgeInsets.only(top: 15.0.sp),
                              child: Obx(() {
                                return GridView.count(
                                  controller: shopController.itemScrollController,
                                  primary: false,
                                  padding: EdgeInsets.only(bottom: 30.sp),
                                  childAspectRatio: (1 / 1.4),
                                  crossAxisSpacing: 14.sp,
                                  mainAxisSpacing: 14.sp,
                                  crossAxisCount: width > 450 ? 4 : 2,
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
            ),
          ),
        ],
      );
    });
  }
}
