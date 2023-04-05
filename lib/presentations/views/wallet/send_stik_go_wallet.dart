import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class SendStikGoWallet extends StatelessWidget {
  const SendStikGoWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StaikaWalletController controller = Get.put(StaikaWalletController());
    return GestureDetector(
      onTap: () {
        controller.focusNode.unfocus();
      },
      child: DefaultContainer(
        titleText: 'GO 지갑으로 보내기',
        backgroundColor: subBg01Color,
        headerBackgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 28.0.sp, left: 22.sp, right: 22.sp),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 19.sp,
                    foregroundImage: controller.assetStik.value != null
                        ? CachedNetworkImageProvider(
                            controller.assetStik.value!.logoUrl,
                          )
                        : Image.asset(
                            'assets/images/ic_launcher.png',
                            width: 23.sp,
                          ).image,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          '보유 중',
                          color: lightGrayColor,
                          fontSize: 12,
                          lineHeight: 13,
                          fontWeight: 600,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0.sp),
                          child: StyledText(
                            '${controller.assetStik.value!.uiAmount} STIK',
                            fontSize: 18,
                            lineHeight: 19,
                            fontWeight: 500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0.sp, left: 28.sp, right: 28.sp),
              child: StyledText(
                '보내는 STIK',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0.sp, left: 28.sp, right: 28.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: '금액을 입력하세요(STIK)',
                      hintStyle: TextStyle(
                        color: deepGrayColor,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixText: ' STIK',
                      suffixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF363841)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF363841)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: controller.stikAmountTextController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      height: 28 / 24,
                      fontWeight: FontWeight.w600,
                    ),
                    autofocus: false,
                    cursorColor: Colors.white,
                    focusNode: controller.focusNode,
                    onChanged: (value) => controller.setAmount(value),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0.sp),
                    child: StyledText(
                      '* 보내는 STIK의 0.5%가 전송수수료로 추가 사용됩니다.',
                      fontSize: 12,
                      lineHeight: 20,
                      color: deepGrayColor,
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
}
