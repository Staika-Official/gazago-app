import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class BuyTik extends StatelessWidget {
  const BuyTik({super.key});

  Widget getConfirmationBottomSheet(WalletMasterController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: popupBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.sp),
          topRight: Radius.circular(12.sp),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.sp, bottom: 22.sp),
              child: StyledText(
                'charge_taika'.tr(),
                fontSize: 20,
                fontWeight: 600,
                lineHeight: 20,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: controller.tik.value.logoUrl != '' &&
                          controller.tik.value.logoUrl != null
                      ? CachedNetworkImageProvider(
                          controller.tik.value.logoUrl!,
                          headers: imageNetworkHeader,
                        )
                      : const Svg('assets/images/common/ico_token_tik.svg')
                          as ImageProvider,
                  radius: 12.5.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 9.sp),
                  child: StyledText(
                    controller.buyTikAmount.value.toString(),
                    fontSize: 30,
                    lineHeight: 30,
                    fontWeight: 600,
                  ),
                ),
                StyledText(
                  controller.tik.value.symbol!,
                  fontSize: 30,
                  lineHeight: 30,
                  fontWeight: 600,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.sp, left: 20.sp, right: 20.sp),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          'used_stik'.tr(),
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        const StyledText(
                          'STIK',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          'charge_fee'.tr(),
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        const StyledText(
                          'text',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          'remaining_stik'.tr(),
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        const StyledText(
                          'text',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              color: const Color(0xff5e5e66),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 25.sp, bottom: 30.sp, left: 30.sp, right: 30.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    'total_tik_charged'.tr(),
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                  ),
                  const Row(
                    children: [
                      StyledText(
                        '000',
                        fontSize: 24,
                        lineHeight: 24,
                        fontWeight: 700,
                      ),
                      StyledText(
                        ' TIK',
                        fontSize: 24,
                        lineHeight: 24,
                        fontWeight: 400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: StyledText(
                'cannot_cancel_after_charge'.tr(),
                color: skyBlueColor,
                fontSize: 14,
                fontWeight: 500,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.sp,
                right: 20.sp,
                top: 30.sp,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 6.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff3e3e4a),
                          borderRadius: BorderRadius.circular(12.sp),
                          border: Border.all(width: 2, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4.sp),
                            )
                          ],
                        ),
                        child: Ink(
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(12.sp),
                            child: Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: StyledText(
                                'no'.tr(),
                                fontWeight: 600,
                                fontSize: 18,
                                color: const Color(0xfffffdfd),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        // child: ElevatedButton(
                        //   onPressed: () => Get.back(),
                        //   child: const Text('cancel'.tr()),
                        // ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: skyBlueColor,
                          borderRadius: BorderRadius.circular(12.sp),
                          border: Border.all(width: 2, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4.sp),
                            )
                          ],
                        ),
                        child: Ink(
                          child: InkWell(
                            onTap: () => controller.buyTik(
                                int.parse(controller.buyTikAmount.value)),
                            borderRadius: BorderRadius.circular(12.sp),
                            child: Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: StyledText(
                                'yes'.tr(),
                                fontWeight: 600,
                                fontSize: 18,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // child: ElevatedButton(
                      //   onPressed: () => controller.buyTik(int.parse(controller.buyTikAmount.value)),
                      //   child: const Text('in_progress_2'.tr()),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();
    return DefaultContainer(
      backgroundColor: subBg01Color,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: StyledText(
                'charge_taika'.tr(),
                fontSize: 20,
                lineHeight: 20,
                fontWeight: 600,
                color: Colors.white,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('100TIK \u2248 \$10'),
            // ),
            Padding(
              padding: EdgeInsets.only(
                  top: 30.sp, left: 30.sp, right: 30.sp, bottom: 15.sp),
              child: Container(
                padding: EdgeInsets.only(
                    top: 13.sp, left: 14.sp, right: 14.sp, bottom: 18.sp),
                decoration: BoxDecoration(
                  color: subBg02Color,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      foregroundImage: controller.tik.value.logoUrl! != '' ||
                              controller.tik.value.logoUrl != null
                          ? CachedNetworkImageProvider(
                              controller.tik.value.logoUrl!,
                              headers: imageNetworkHeader,
                            )
                          : const Svg('assets/images/common/ico_token_tik.svg')
                              as ImageProvider,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 13.sp),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: TextField(
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          suffixText: ' TIK',
                          hintText: '100',
                          hintStyle: TextStyle(
                            color: const Color(0xff646469),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          suffixStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          focusColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.sp),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        autofocus: true,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            controller.enterBuyTikAmount(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 30.sp,
                right: 30.sp,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),
                        color: const Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6.sp),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5.sp),
                          child: const Center(
                            child: StyledText(
                              '10',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: subBg01Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),
                        color: const Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6.sp),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5.sp),
                          child: const Center(
                            child: StyledText(
                              '100',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: subBg01Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),
                        color: const Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6.sp),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5.sp),
                          child: const Center(
                            child: StyledText(
                              '1000',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: subBg01Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),
                        color: const Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6.sp),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5.sp),
                          child: const Center(
                            child: StyledText(
                              'Max',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: subBg01Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
              child: Column(
                children: [
                  StyledText(
                    'min_charge_1000_tik'.tr(),
                    fontSize: 12,
                    fontWeight: 400,
                    lineHeight: 14,
                    letterSpacing: -0.5,
                    color: const Color(0xff727380),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.sp),
                    child: StyledText(
                      'charge_fee_30_tik'.tr(),
                      fontSize: 12,
                      fontWeight: 400,
                      lineHeight: 14,
                      letterSpacing: -0.5,
                      color: const Color(0xff727380),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Ink(
                        decoration:
                            const BoxDecoration(color: Color(0xff3E3E4A)),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: SizedBox(
                              child: StyledText(
                                'cancel'.tr(),
                                fontSize: 18,
                                fontWeight: 600,
                                lineHeight: 18,
                                color: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Ink(
                        decoration: const BoxDecoration(color: skyBlueColor),
                        child: InkWell(
                          onTap: () => controller.showBuyConfirmation(
                              getConfirmationBottomSheet(controller)),
                          child: Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: SizedBox(
                              child: StyledText(
                                'recharge_1'.tr(),
                                fontSize: 18,
                                fontWeight: 600,
                                lineHeight: 18,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
