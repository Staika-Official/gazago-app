import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
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
        child: Obx(() {
          return Column(
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
                              headers: imageNetworkHeader,
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
                              '${formatDecimalPlaces(double.parse(controller.assetStik.value!.uiAmountString), 4, isAutoDecimal: true)} STIK',
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
                child: const StyledText(
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
                        suffixText: controller.focusNode != null ? ' STIK' : '',
                        suffixStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Color(0xFF363841)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Color(0xFF363841)),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      controller: controller.stikAmountTextController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                      textInputAction: TextInputAction.go,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'(\d*\.?\d*)')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) {
                            return newValue.copyWith(text: '');
                          } else if (newValue.text.compareTo(oldValue.text) != 0) {
                            RegExp exp = RegExp("^(([1-9]\\d{0,8})|0)(\\.\\d{0,9}?)?\$");
                            if (exp.hasMatch(newValue.text)) {
                              return newValue;
                            } else {
                              return oldValue;
                            }
                          } else {
                            return newValue;
                          }
                        }),
                      ],
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
                      onSubmitted: (val) => controller.openSendStikGoWalletAlert(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.isFetching.value
                    ? Container(
                        color: subBg01Color,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: popupBgColor,
                            height: 60.sp,
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                                child: Center(
                                  child: StyledText(
                                    '보내기',
                                    color: deepGrayColor,
                                    fontSize: 18,
                                    fontWeight: 500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    : Container(
                        color: subBg01Color,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: controller.isValid.value ? skyBlueColor : popupBgColor,
                            height: 60.sp,
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: controller.isValid.value ? () => controller.openSendStikGoWalletAlert() : null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                                child: Center(
                                  child: StyledText(
                                    '보내기',
                                    color: controller.isValid.value ? Colors.black : deepGrayColor,
                                    fontSize: 18,
                                    fontWeight: 500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
              )
            ],
          );
        }),
      ),
    );
  }
}
