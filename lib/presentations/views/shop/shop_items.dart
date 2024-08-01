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
  const ShopItems({super.key});

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
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
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
                                            placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                                            headers: imageNetworkHeader,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: item.itemImageUrl!,
                                            fit: BoxFit.fitHeight,
                                            placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
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
                                            iconShopRewardPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '${formatDecimalPlaces(item.minGoProfit!, 0)}-${formatDecimalPlaces(item.maxGoProfit!, 0)}',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointCyan,
                                                    ),
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
                                            iconShopDurabilityLightPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '${formatDecimalPlaces(item.minDurability!, 0)}-${formatDecimalPlaces(item.maxDurability!, 0)}',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointPurple,
                                                    ),
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
                                            iconShopStaminaPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '${formatDecimalPlaces(item.minStamina!, 0)}-${formatDecimalPlaces(item.maxStamina!, 0)}',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointYellowgreen,
                                                    ),
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
                                            iconShopLuckPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '${formatDecimalPlaces(item.minLuck!, 0)}-${formatDecimalPlaces(item.maxLuck!, 0)}',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointPink,
                                                    ),
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
                                            iconShopStaminaPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '+${formatDecimalPlaces(item.recoveryStamina!, 0)} 회복',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointYellowgreen,
                                                    ),
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
                                            iconShopDurabilityLightPng,
                                            Padding(
                                              padding: EdgeInsets.only(left: 3.0.sp),
                                              child: Text(
                                                '+${formatDecimalPlaces(item.repairDurability!, 0)} 수리',
                                                style: AppTextStyleData.regular().numBodySemiboldSm.copyWith(
                                                      color: AppColorData.regular().colorPointPurple,
                                                    ),
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
                    bottom: -1,
                    top: null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff222229),
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
          Container(
            height: 35.sp,
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(
              width: 1,
              color: AppColorData.regular().colorBorderSecondary,
            ))),
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
                tabAlignment: TabAlignment.start,
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColorData.regular().colorBgPrimary,
                              border: Border.all(
                                width: 1,
                                color: AppColorData.regular().colorBorderSecondary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  shopController.isSelectedSortString.value,
                                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                        color: AppColorData.regular().colorTextSecondary,
                                      ),
                                ),
                                iconArrowDown,
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (shopController.isSelectAllItems.value)
                              Padding(
                                padding: EdgeInsets.only(right: 10.0.sp),
                                child: Text(
                                  '전체',
                                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                        color: AppColorData.regular().colorTextSecondary,
                                      ),
                                ),
                              ),
                            InkWell(
                              onTap: () => shopController.showItemFilterPopup(),
                              child: Container(
                                width: 32,
                                height: 32,
                                padding: const EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: AppColorData.regular().colorBorderSecondary,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: shopController.isSelectAllItems.value ? iconShopFilter : iconShopFilterActive,
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
                                child: const Center(child: CircularProgressIndicator(color:skyBlueColor)),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 120.sp),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    iconShopEmpty,
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.sp),
                                      child: const StyledText(
                                        '검색 결과가 없어요.',
                                        color: lightGrayColor,
                                        fontSize: 16,
                                        lineHeight: 18,
                                        fontWeight: 500,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        if (shopController.filteredCategory.isNotEmpty)
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
                                          padding: EdgeInsets.only(top: 32.0.sp),
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
                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                width: 1,
                                                                color: getItemGradeColor(entry.value),
                                                              ),
                                                              borderRadius: BorderRadius.circular(20.sp),
                                                            ),
                                                            child: Text(
                                                              entry.value!,
                                                              style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                                                    color: getItemGradeColor(entry.value),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                    if (shopController.isSelectNftItems.value)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1,
                                                            color: AppColorData.regular().colorPointOrange,
                                                          ),
                                                          borderRadius: BorderRadius.circular(20.sp),
                                                        ),
                                                        child: Text(
                                                          'NFT',
                                                          style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                                                color: AppColorData.regular().colorPointOrange,
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
