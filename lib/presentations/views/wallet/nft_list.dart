import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/wallet_nft_list_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/nft_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class NftList extends StatelessWidget {
  const NftList({super.key});

  List<Widget> renderNftItems(bool isGoWallet, WalletNftListController controller, List<dynamic> nftList) {
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
                        child: SvgPicture.asset('assets/images/shop/ico_nft.svg'),
                      ),
                      Positioned(
                        left: 0.sp,
                        top: 0,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Center(child: getItemGradeIcon(nftItem.itemGrade)),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 37),
                            child: Center(
                              child: SizedBox(
                                width: 92.sp,
                                child: CachedNetworkImage(
                                  imageUrl: nftItem.itemImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.sp, bottom: 8.sp),
                            child: Text(
                              nftItem.itemName,
                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                    color: AppColorData.regular().colorTextSecondary,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColorData.regular().colorBorderTertiary),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#${nftItem.serialNumber}',
                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                    color: AppColorData.regular().colorTextTertiary,
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
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (nftItem.itemStat!.goProfit! > 0)
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
                                                    '${formatDecimalPlaces(nftItem.itemStat!.goProfit!, 0)}',
                                                    fontSize: 12,
                                                    fontWeight: 600,
                                                    letterSpacing: -.1,
                                                    color: skyBlueColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.durability! > 0)
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
                                                    '${formatDecimalPlaces(nftItem.itemStat!.durability!, 0)}',
                                                    fontSize: 12,
                                                    fontWeight: 600,
                                                    letterSpacing: -.1,
                                                    color: AppColorData.regular().colorPointPurple,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.stamina! > 0)
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
                                                    '${formatDecimalPlaces(nftItem.itemStat!.stamina!, 0)}',
                                                    fontSize: 12,
                                                    fontWeight: 600,
                                                    letterSpacing: -.1,
                                                    color: lightGreenColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (nftItem.itemStat!.luck! > 0)
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
                                                    '${formatDecimalPlaces(nftItem.itemStat!.luck!, 0)}',
                                                    fontSize: 12,
                                                    fontWeight: 600,
                                                    color: pinkColor,
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
                              ),
                            ),
                          if (nftItem.itemCategory == 'SHOES')
                            Container(
                              width: constraints.maxWidth,
                              height: 12,
                              margin: EdgeInsets.only(
                                left: 17.sp,
                                right: 17.sp,
                                top: 12.sp,
                                bottom: 16.sp,
                              ),
                              decoration: ShapeDecoration(
                                color: AppColorData.regular().colorBgSecondary,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: AppColorData.regular().colorBorderBlack,
                                    blurRadius: 0,
                                    offset: Offset(0, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: LayoutBuilder(builder: (context, constraints) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: nftItem.durability! > 100 ? constraints.maxWidth : constraints.maxWidth * (nftItem.durability! / 100),
                                      height: 12,
                                      padding: const EdgeInsets.all(2),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        // color: nftItem.durability! < 30 ? textRedColor : AppColorData.regular().colorPointPurple,
                                        color: nftItem.durability! < 30 ? textRedColor : AppColorData.regular().colorPointPurple,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            )
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
                              child: CachedNetworkImage(
                                imageUrl: nftItem.metadata!.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Text(
                            nftItem.name!,
                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                  color: AppColorData.regular().colorTextSecondary,
                                ),
                            textAlign: TextAlign.center,
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
        child: controller.isFromGoWallet.value
            ? controller.nftList.isEmpty
                ? Center(
                    heightFactor: 2.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(child: iconEmptyRoundedBg),
                        Padding(
                          padding: EdgeInsets.only(top: 20.sp),
                          child: Text(
                            '보유한 NFT가 없어요',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextSecondary,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.sp),
                          child: Text(
                            'NFT는 STIK로 구매할 수 있어요.',
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
                                  'NFT 구매하기',
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
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GridView.count(
                      primary: false,
                      padding: EdgeInsets.only(bottom: 30.sp),
                      childAspectRatio: controller.isFromGoWallet.value ? (1 / 1.5) : 1,
                      crossAxisSpacing: 10.sp,
                      mainAxisSpacing: 10.sp,
                      crossAxisCount: width > 450 ? 4 : 2,
                      children: <Widget>[
                        ...renderNftItems(
                          controller.isFromGoWallet.value,
                          controller,
                          controller.nftList,
                        )
                      ],
                    ),
                  )
            : controller.onChainNftList.isEmpty
                ? Center(
                    heightFactor: 2.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(child: iconEmptyRoundedBg),
                        Padding(
                          padding: EdgeInsets.only(top: 20.sp),
                          child: Text(
                            '보유한 NFT가 없어요',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextSecondary,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.sp),
                          child: Text(
                            'NFT는 STIK로 구매할 수 있어요.',
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
                                  'NFT 구매하기',
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
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GridView.count(
                      primary: false,
                      padding: EdgeInsets.only(bottom: 30.sp),
                      childAspectRatio: controller.isFromGoWallet.value ? (1 / 1.4) : 1,
                      crossAxisSpacing: 10.sp,
                      mainAxisSpacing: 10.sp,
                      crossAxisCount: width > 450 ? 4 : 2,
                      children: <Widget>[
                        ...renderNftItems(
                          controller.isFromGoWallet.value,
                          controller,
                          controller.onChainNftList,
                        )
                      ],
                    ),
                  ),
      );
    });
  }
}
