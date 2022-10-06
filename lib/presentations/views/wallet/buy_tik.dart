import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class BuyTik extends StatelessWidget {
  BuyTik({Key? key}) : super(key: key);

  Widget getConfirmationBottomSheet(WalletMasterController controller) {
    AssetTokenBalanceUiModel tik = controller.spendingTokenUiList.singleWhere((token) => token.mint == '1');
    AssetTokenBalanceUiModel stik = controller.spendingTokenUiList.singleWhere((token) => token.mint == '2');

    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('진행하시겠습니까?'),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(stik.meta!.logoUrl),
                        ),
                        Text('${double.parse(controller.buyTikAmount.value) * 0.00333333333} ${stik.meta!.symbol}'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(Icons.arrow_right_alt),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          foregroundImage: tik.meta?.logoUrl != '' ? CachedNetworkImageProvider(tik.meta!.logoUrl) : Svg('assets/images/ico_token_tik.svg') as ImageProvider,
                        ),
                        Text('${controller.buyTikAmount.value} ${tik.meta!.symbol}'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('취소'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => controller.buyTik(int.parse(controller.buyTikAmount.value)),
                      child: Text('진행'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();
    return DefaultContainer(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Taika를 충전하시겠습니까?'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('100TIK \u2248 \$10'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  suffixText: ' TIK',
                  hintText: '100',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.enterBuyTikAmount(value),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('취소'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => controller.showBuyConfirmation(getConfirmationBottomSheet(controller)),
                          child: Text('충전'),
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
