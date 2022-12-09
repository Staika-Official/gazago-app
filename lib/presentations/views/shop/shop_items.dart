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
                          decoration: BoxDecoration(
                            color: getItemGradeColor(item.itemGrade),
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.sp),
                              bottomLeft: Radius.circular(5.sp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(1.sp, 2.sp),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 90.sp,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 10.0.sp),
                            child: StyledText(
                              '${item.itemGrade}',
                              color: item.itemGrade == 'POOR' ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                              fontWeight: 600,
                              fontSize: item.itemGrade.length < 6 ? 10 : 8,
                              lineHeight: 10,
                              fontFamily: 'Montserrat',
                              letterSpacing: item.itemGrade.length < 6 ? 4 : 1.5,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0.sp),
                              child: SizedBox(
                                height: 115.sp,
                                child: Image.asset(
                                  item.itemImageUrl!,
                                ),
                              ),
                              // child: CachedNetworkImage(
                              //   imageUrl: item.itemImageUrl!,
                              //   fit: BoxFit.fitWidth,
                              //   placeholder: (context, url) => const CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              // ),
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
                                              item.rewardRate,
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
                                                    item.durability,
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
                                              item.staminaReduceRate,
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
                            StyledText(
                              '마감임박',
                              fontSize: 12.sp,
                              fontWeight: 600,
                              color: skyBlueColor,
                            ),
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
    // ShopController shopController = Get.put(ShopController());
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
                            child: iconShopFilter,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
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
              )
            ],
          ),
        ),
      );
    });
  }
}
