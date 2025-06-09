import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/solana_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class LaboratorySolanaTransfer extends StatelessWidget {
  const LaboratorySolanaTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    SolanaController solanaController = Get.put(SolanaController());

    return DefaultContainer(
      titleText: 'send_solana'.tr(),
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  title: StyledText(
                    'Solana',
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                  leading: Radio<String>(
                    value: 'SOL',
                    groupValue: solanaController.symbol.value,
                    onChanged: (value) => solanaController.setSymbol(value),
                  ),
                ),
                ListTile(
                  title: StyledText(
                    'staika'.tr(),
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                  leading: Radio<String>(
                    value: 'STIKA',
                    groupValue: solanaController.symbol.value,
                    onChanged: (value) => solanaController.setSymbol(value),
                  ),
                ),
                TextFormField(
                  initialValue: solanaController.toAddress.value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1,
                  ),
                  onChanged: (name) => solanaController.setToAddress(name),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: popupBgColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: popupBgColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'enter_recipient_address'.tr(),
                    hintStyle: TextStyle(
                      color: deepGrayColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  cursorColor: skyBlueColor,
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  initialValue: solanaController.uiAmount.value.toString(),
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
                  autofocus: false,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => solanaController.setAmount(value),
                ),
                GazagoButton(
                  onTap: () => solanaController.sendTransfer(),
                  buttonText: 'submit'.tr(),
                  buttonColor: skyBlueColor,
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                const StyledText(
                  'Transaction: ',
                  fontSize: 20,
                  fontWeight: 500,
                  color: Colors.white,
                ),
                StyledText(
                  '${solanaController.transaction}',
                  fontSize: 20,
                  fontWeight: 500,
                  lineHeight: 25,
                  color: Colors.white,
                ),
                const StyledText(
                  'Solscan URL: ',
                  fontSize: 20,
                  fontWeight: 500,
                  color: Colors.white,
                ),
                StyledText(
                  '${solanaController.solscanUrl}',
                  fontSize: 20,
                  fontWeight: 500,
                  lineHeight: 25,
                  color: Colors.white,
                ),
                GazagoButton(
                  onTap: () => solanaController.launchURL(),
                  buttonText: 'solscan_link'.tr(),
                  buttonColor: skyBlueColor,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
