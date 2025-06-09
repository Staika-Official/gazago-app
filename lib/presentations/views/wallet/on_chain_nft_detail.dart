import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/wallet_on_chain_nft_detail_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';


class OnChainNftDetail extends StatelessWidget {
  const OnChainNftDetail({super.key});

  @override
  Widget build(BuildContext context) {
    WalletOnChainNftDetailController controller = Get.put(WalletOnChainNftDetailController());

    return Obx(() {
      return DefaultContainer(
        titleText: removeSerialNumberString(controller.nftDetail.value?.name ?? ''),
        child: controller.nftDetail.value != null
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8, left: 16.sp, right: 16.sp, bottom: 28.sp),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColorData.regular().colorBgTertiary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 2,
                                color: AppColorData.regular().colorBorderBlack,
                              ),
                              boxShadow: [
                                const BoxShadow(
                                  color: Color(0xFF000000),
                                  blurRadius: 0,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(left: 24.sp, right: 24.sp, child: SvgPicture.asset('assets/images/shop/ico_nft_detail.svg')),
                                Center(
                                  child: Container(
                                    width: 174.sp,
                                    height: 174.sp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: (controller.nftDetail.value!.json!.properties!.files![0].type.runtimeType != bool &&
                                            controller.nftDetail.value!.json!.properties!.files![0].type.contains('svg'))
                                        ? SvgPicture.network(
                                            fit: BoxFit.cover,
                                            controller.nftDetail.value!.json!.image!,
                                            placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                                            headers: imageNetworkHeader,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: controller.nftDetail.value!.json!.image!,
                                            fit: BoxFit.cover,
                                            httpHeaders: imageNetworkHeader,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.nftDetail.value!.json!.attributes != null)
                            Column(
                              children: [
                                ...controller.nftDetail.value!.json!.attributes!
                                    .map((attribute) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                attribute.traitType,
                                                style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                                      color: AppColorData.regular().colorTextPrimary,
                                                    ),
                                              ),
                                              Text(
                                                '${attribute.value}',
                                                style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                                      color: AppColorData.regular().colorTextTertiary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList()
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      right: 16,
                      left: 16,
                      bottom: 36,
                    ),
                    child: GazagoButton(
                      buttonText: 'send_to_go_wallet'.tr(),
                      onTap: () async {
                        controller.showRequestSendNftDialog();
                      },
                    ),
                  ),
                ],
              )
            : Container()
        // SkeletonTheme(
        //         shimmerGradient: LinearGradient(
        //           colors: [
        //             AppColorData.regular().colorBgSecondary,
        //             AppColorData.regular().colorBgTertiary,
        //             AppColorData.regular().colorBgSecondary,
        //           ],
        //           stops: [
        //             0,
        //             0.5,
        //             1,
        //           ],
        //           begin: Alignment(-2.4, -0.2),
        //           end: Alignment(2.4, 0.2),
        //           tileMode: TileMode.clamp,
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(16),
        //           child: Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(bottom: 8),
        //                 child: SkeletonLine(
        //                   style: SkeletonLineStyle(
        //                     height: 230,
        //                     maxLength: MediaQuery.of(context).size.width,
        //                     borderRadius: BorderRadius.circular(12),
        //                   ),
        //                 ),
        //               ),
        //               for (int i = 0; i < 7; i++)
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 16),
        //                   child: Row(
        //                     children: [
        //                       SkeletonLine(
        //                         style: SkeletonLineStyle(
        //                           width: 70,
        //                           height: 32,
        //                           maxLength: MediaQuery.of(context).size.width,
        //                           borderRadius: BorderRadius.circular(8),
        //                         ),
        //                       ),
        //                       SizedBox(
        //                         width: 16,
        //                       ),
        //                       Expanded(
        //                         child: SkeletonLine(
        //                           style: SkeletonLineStyle(
        //                             height: 32,
        //                             maxLength: MediaQuery.of(context).size.width,
        //                             borderRadius: BorderRadius.circular(8),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //             ],
        //           ),
        //         ),
        //       ),
      );
    });
  }
}
