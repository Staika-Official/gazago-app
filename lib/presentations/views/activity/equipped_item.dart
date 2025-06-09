import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations//components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/views/inventory/equipped_items_grid.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class EquippedItems extends StatelessWidget {
  const EquippedItems({super.key});

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.isRegistered<InventoryController>()
        ? Get.find<InventoryController>()
        : Get.put(InventoryController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: 'equipped_items'.tr(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_activity_road.png'),
            alignment: Alignment(0, 1),
          ),
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0.sp, vertical: 20.0.sp),
                // child: EquippedItemsGrid(controller: controller),
                child: EquippedItemsGrid(controller: controller),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0.sp, bottom: 15.sp, left: 30.0.sp, right: 30.0.sp),
                child: Obx(() {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${controller.equippedRewardRate.toInt()}',
                            style: AppTextStyleData.regular()
                                .enBodyMediumXl
                                .copyWith(
                                  color: AppColorData.regular().colorPointCyan,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                iconShopRewardPng,
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0.sp),
                                  child: Text(
                                    'go_accumulation'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koCaptionMediumMd
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorPointCyan,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${controller.equippedAbrasionRate.toInt()}',
                            style: AppTextStyleData.regular()
                                .enBodyMediumXl
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorPointPurple,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                iconShopDurabilityLightPng,
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0.sp),
                                  child: Text(
                                    'durability_resistance'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koCaptionMediumMd
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorPointPurple,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${controller.equippedStaminaReduceRate.toInt()}',
                            style: AppTextStyleData.regular()
                                .enBodyMediumXl
                                .copyWith(
                                  color: AppColorData.regular()
                                      .colorPointYellowgreen,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                iconShopStaminaPng,
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0.sp),
                                  child: Text(
                                    'stamina_resistance'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koCaptionMediumMd
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorPointYellowgreen,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${controller.equippedLuckRate.toInt()}',
                            style: AppTextStyleData.regular()
                                .enBodyMediumXl
                                .copyWith(
                                  color: AppColorData.regular().colorPointPink,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0.sp),
                                  child: iconShopLuckPng,
                                ),
                                Text(
                                  'luck'.tr(),
                                  style: AppTextStyleData.regular()
                                      .koCaptionMediumMd
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointPink,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E0E10),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.sp),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                  child: Text(
                    'higher_value_better'.tr(),
                    style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
