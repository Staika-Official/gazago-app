import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class BuyTik extends StatelessWidget {
  BuyTik({Key? key}) : super(key: key);

  Widget getConfirmationBottomSheet(WalletMasterController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff363841),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 22),
              child: StyledText(
                'Taika를 충전하시겠습니까?',
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
                  foregroundImage:
                      controller.tik.value.meta?.logoUrl != '' ? CachedNetworkImageProvider(controller.tik.value.meta!.logoUrl) : const Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
                  radius: 12.5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 9),
                  child: StyledText(
                    controller.buyTikAmount.value.toString(),
                    fontSize: 30,
                    lineHeight: 30,
                    fontWeight: 600,
                  ),
                ),
                StyledText(
                  controller.tik.value.meta!.symbol,
                  fontSize: 30,
                  lineHeight: 30,
                  fontWeight: 600,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          '사용 STIK',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        StyledText(
                          'STIK',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          '충전 수수료',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        StyledText(
                          'text',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          '충전 후 STIK잔액',
                          fontSize: 18,
                          lineHeight: 18,
                          fontWeight: 500,
                        ),
                        StyledText(
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
              color: Color(0xff5e5e66),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 30, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    '총 충전 TIK',
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                  ),
                  Row(
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
                '충전이 완료되면 취소할 수 없습니다.',
                color: Color(0xff0ee6f3),
                fontSize: 14,
                fontWeight: 500,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff3e3e4a),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 2, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Ink(
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: StyledText(
                                '아니요',
                                fontWeight: 600,
                                fontSize: 18,
                                color: Color(0xfffffdfd),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        // child: ElevatedButton(
                        //   onPressed: () => Get.back(),
                        //   child: const Text('취소'),
                        // ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff0EE6F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 2, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Ink(
                          child: InkWell(
                            onTap: () => controller.buyTik(int.parse(controller.buyTikAmount.value)),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: StyledText(
                                '네',
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
                      //   child: const Text('진행'),
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
      backgroundColor: const Color(0xff1D1D26),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: StyledText(
                'Taika를 충전하시겠습니까?',
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
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 15),
              child: Container(
                padding: const EdgeInsets.only(top: 13, left: 14, right: 14, bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xff2a2b33),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      foregroundImage: controller.tik.value.meta?.logoUrl != ''
                          ? CachedNetworkImageProvider(controller.tik.value.meta!.logoUrl)
                          : const Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 13),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          suffixText: ' TIK',
                          hintText: '100',
                          hintStyle: TextStyle(
                            color: Color(0xff646469),
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                          suffixStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                          focusColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                        autofocus: true,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => controller.enterBuyTikAmount(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5),
                          child: Center(
                            child: StyledText(
                              '10',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: Color(0xff1d1d26),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5),
                          child: Center(
                            child: StyledText(
                              '100',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: Color(0xff1d1d26),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5),
                          child: Center(
                            child: StyledText(
                              '1000',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: Color(0xff1d1d26),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff727380),
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () => null,
                        child: Padding(
                          padding: EdgeInsets.all(7.5),
                          child: Center(
                            child: StyledText(
                              'Max',
                              fontSize: 16,
                              fontWeight: 500,
                              lineHeight: 16,
                              letterSpacing: -0.5,
                              color: Color(0xff1d1d26),
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
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  StyledText(
                    '* 최소 1,000 TIK부터 충전할 수 있습니다.',
                    fontSize: 12,
                    fontWeight: 400,
                    lineHeight: 14,
                    letterSpacing: -0.5,
                    color: Color(0xff727380),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: StyledText(
                      '* 충전 수수료 30 TIK 제외 후 나머지 금액이 충전됩니다.',
                      fontSize: 12,
                      fontWeight: 400,
                      lineHeight: 14,
                      letterSpacing: -0.5,
                      color: Color(0xff727380),
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
                        decoration: BoxDecoration(color: Color(0xff3E3E4A)),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: SizedBox(
                              child: StyledText(
                                '취소',
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
                        decoration: BoxDecoration(color: Color(0xff0EE6F3)),
                        child: InkWell(
                          onTap: () => controller.showBuyConfirmation(getConfirmationBottomSheet(controller)),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: SizedBox(
                              child: StyledText(
                                '충전하기',
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
