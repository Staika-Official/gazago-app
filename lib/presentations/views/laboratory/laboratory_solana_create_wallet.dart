import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/solana_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class LaboratorySolanaCreateWallet extends StatelessWidget {
  const LaboratorySolanaCreateWallet({super.key});

  @override
  Widget build(BuildContext context) {
    SolanaController solanaController = Get.put(SolanaController());

    return DefaultContainer(
      titleText: 'create_solana_wallet'.tr(),
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: Obx(() {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                GazagoButton(
                  onTap: () => solanaController.createWallet(),
                  buttonText: 'create_wallet_1'.tr(),
                  buttonColor: skyBlueColor,
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                const StyledText(
                  'Address: ',
                  fontSize: 20,
                  fontWeight: 500,
                  color: Colors.white,
                ),
                StyledText(
                  '${solanaController.address}',
                  fontSize: 20,
                  fontWeight: 500,
                  lineHeight: 25,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
