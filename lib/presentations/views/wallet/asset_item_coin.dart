import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';

class AssetItemCoin extends StatelessWidget {
  final AssetTokenBalanceUiModel asset;
  final VoidCallback onTap;
  final VoidCallback? onTapButton;
  final String? buttonText;
  const AssetItemCoin({Key? key, required this.asset, required this.onTap, this.onTapButton, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  foregroundImage: asset.meta?.logoUrl != '' ? CachedNetworkImageProvider(asset.meta!.logoUrl) : Svg('assets/images/ico_token_tik.svg') as ImageProvider,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(asset.meta!.name),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text((asset.amount! / pow(10, asset.decimals!)).toString() + ' ' + asset.meta!.symbol),
                    asset.price!.isNotEmpty ? Text('\u2248 \$${asset.amount! / pow(10, asset.decimals!)}') : Container(),
                  ],
                )
              ],
            ),
            onTapButton != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTapButton,
                        child: Text(buttonText!),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
