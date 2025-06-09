import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/wallet_nft_list_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/nft_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class NftList extends StatelessWidget {
  const NftList({super.key});

  List<Widget> renderNftItems(bool isGoWallet,
      WalletNftListController controller, List<dynamic> nftList) {
    if (isGoWallet) {
      nftList as List<InventoryItemModel>;
      return nftList
          .map(
            (InventoryItemModel nftItem) => GestureDetector(
              onTap: () => controller.moveToItemDetail(itemId: nftItem.id),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColorData.regular().colorBgTertiary,
                  border: Border.all(
                    color: AppColorData.regular().colorBorderBlack,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned(
                        right: 10.sp,
                        top: 10.sp,
                        child: SvgPicture.asset(
                          'assets/images/shop/ico_nft.svg',
                          height: 120,
                          width: 48,
                        ),
                      ),
                      Positioned(
                        left: 0.sp,
                        top: -1,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Center(
                              child: getItemGradeIcon(nftItem.itemGrade)),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 37),
                            child: Center(
                              child: SizedBox(
                                width: 92.sp,
                                height: 92.sp,
                                child: nftItem.itemImageUrl.contains('.svg')
                                    ? SvgPicture.network(
                                        fit: BoxFit.cover,
                                        nftItem.itemImageUrl,
                                        placeholderBuilder: (BuildContext
                                                context) =>
                                            const Center(
                                                child: SizedBox.square(
                                                    dimension: 40,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                skyBlueColor))),
                                        headers: imageNetworkHeader,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: nftItem.itemImageUrl,
                                        fit: BoxFit.cover,
                                        httpHeaders: imageNetworkHeader,
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.sp, bottom: 8.sp),
                            child: Text(
                              nftItem.itemName,
                              style: AppTextStyleData.regular()
                                  .koBodyMediumMd
                                  .copyWith(
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColorData.regular()
                                      .colorBorderTertiary),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#${nftItem.serialNumber}',
                              style: AppTextStyleData.regular()
                                  .numBodySemiboldSm
                                  .copyWith(
                                    color: AppColorData.regular()
                                        .colorTextTertiary,
                                  ),
                            ),
                          ),
                          if (nftItem.itemStat!.goProfit != 0 ||
                              nftItem.itemStat!.durability != 0 ||
                              nftItem.itemStat!.stamina != 0 ||
                              nftItem.itemStat!.luck != 0 ||
                              nftItem.itemStat!.recoveryStamina != 0 ||
                              nftItem.itemStat!.repairDurability != 0)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (nftItem.itemStat!.goProfit! > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 16.sp,
                                                  height: 16.sp,
                                                  child: iconShopRewardPng,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.sp),
                                                  child: Text(
                                                    formatDecimalPlaces(
                                                        nftItem.itemStat!
                                                            .goProfit!,
                                                        0),
                                                    style: AppTextStyleData
                                                            .regular()
                                                        .numBodySemiboldSm
                                                        .copyWith(
                                                          color: AppColorData
                                                                  .regular()
                                                              .colorPointCyan,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.durability! > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 16.sp,
                                                  height: 16.sp,
                                                  child:
                                                      iconShopDurabilityLightPng,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.sp),
                                                  child: Text(
                                                    formatDecimalPlaces(
                                                        nftItem.itemStat!
                                                            .durability!,
                                                        0),
                                                    style: AppTextStyleData
                                                            .regular()
                                                        .numBodySemiboldSm
                                                        .copyWith(
                                                          color: AppColorData
                                                                  .regular()
                                                              .colorPointPurple,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.stamina! > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 16.sp,
                                                  height: 16.sp,
                                                  child: iconShopStaminaPng,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.sp),
                                                  child: Text(
                                                    formatDecimalPlaces(
                                                        nftItem
                                                            .itemStat!.stamina!,
                                                        0),
                                                    style: AppTextStyleData
                                                            .regular()
                                                        .numBodySemiboldSm
                                                        .copyWith(
                                                          color: AppColorData
                                                                  .regular()
                                                              .colorPointYellowgreen,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.luck! > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 16.sp,
                                                  height: 16.sp,
                                                  child: iconShopLuckPng,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.sp),
                                                  child: Text(
                                                    formatDecimalPlaces(
                                                        nftItem.itemStat!.luck!,
                                                        0),
                                                    style: AppTextStyleData
                                                            .regular()
                                                        .numBodySemiboldSm
                                                        .copyWith(
                                                          color: AppColorData
                                                                  .regular()
                                                              .colorPointPink,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (nftItem.itemCategory == 'SHOES')
                                      Container(
                                        width: constraints.maxWidth,
                                        height: 12,
                                        margin: EdgeInsets.only(
                                          left: 17.sp,
                                          right: 17.sp,
                                          top: 12.sp,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: AppColorData.regular()
                                              .colorBgSecondary,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: AppColorData.regular()
                                                  .colorBorderBlack,
                                              blurRadius: 0,
                                              offset: Offset(0, 2),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: nftItem.durability! > 100
                                                    ? constraints.maxWidth
                                                    : constraints.maxWidth *
                                                        (nftItem.durability! /
                                                            100),
                                                height: 12,
                                                padding:
                                                    const EdgeInsets.all(2),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  // color: nftItem.durability! < 30 ? textRedColor : AppColorData.regular().colorPointPurple,
                                                  color: nftItem.durability! <
                                                          30
                                                      ? textRedColor
                                                      : AppColorData.regular()
                                                          .colorPointPurple,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            ),
          )
          .toList();
    } else {
      nftList as List<NftModel>;
      return nftList
          .map(
            (NftModel nftItem) => GestureDetector(
              onTap: () => controller.moveToItemDetail(nftItem: nftItem),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColorData.regular().colorBgTertiary,
                  border: Border.all(
                    color: AppColorData.regular().colorBorderBlack,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10.sp,
                      top: 10.sp,
                      child: SvgPicture.asset('assets/images/shop/ico_nft.svg'),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 92.sp,
                              height: 92.sp,
                              child: (nftItem.metadata!.properties!.files![0]
                                              .type.runtimeType !=
                                          bool &&
                                      nftItem
                                          .metadata!.properties!.files![0].type
                                          .contains('svg'))
                                  ? SvgPicture.network(
                                      fit: BoxFit.cover,
                                      nftItem.metadata!.image!,
                                      placeholderBuilder: (BuildContext
                                              context) =>
                                          const Center(
                                              child: SizedBox.square(
                                                  dimension: 40,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color:
                                                              skyBlueColor))),
                                      headers: imageNetworkHeader,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: nftItem.metadata!.image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Center(
                            child: Text(
                              removeSerialNumberString(nftItem.name!),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumMd
                                  .copyWith(
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    WalletNftListController controller = Get.put(WalletNftListController());
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      return DefaultContainer(
        titleText: 'NFT',
        child:
            (controller.isFromGoWallet.value && controller.nftList.isEmpty) ||
                    (!controller.isFromGoWallet.value &&
                        controller.onChainNftList.isEmpty)
                ? controller.isLoadingInProgress.value
                    ? SizedBox()
                    : NoNftInPossession(controller: controller)
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: GridView.count(
                      primary: false,
                      padding: EdgeInsets.only(bottom: 30.sp),
                      childAspectRatio:
                          controller.isFromGoWallet.value ? (1 / 1.5) : 1,
                      crossAxisSpacing: 10.sp,
                      mainAxisSpacing: 10.sp,
                      crossAxisCount: width > 450 ? 4 : 2,
                      children: <Widget>[
                        ...renderNftItems(
                          controller.isFromGoWallet.value,
                          controller,
                          controller.isFromGoWallet.value
                              ? controller.nftList
                              : controller.onChainNftList,
                        )
                      ],
                    ),
                  ),
      );
    });
  }
}

class NoNftInPossession extends StatelessWidget {
  const NoNftInPossession({
    super.key,
    required this.controller,
  });

  final WalletNftListController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(child: iconEmptyRoundedBg),
          Padding(
            padding: EdgeInsets.only(top: 20.sp),
            child: Text(
              'no_nfts_owned'.tr(),
              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextSecondary,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.sp),
            child: Text(
              'nft_purchase_stik'.tr(),
              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                    color: AppColorData.regular().colorTextTertiary,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.sp),
            child: GestureDetector(
              onTap: () => controller.moveToShop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'buy_nft'.tr(),
                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                          color: AppColorData.regular().colorTextTertiary,
                        ),
                  ),
                  iconChevronRightTertiary,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
