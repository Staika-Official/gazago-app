import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:step_go/platform/models/asset_item_coin_model.dart';

class AssetItemCoin extends StatelessWidget {
  final AssetItemCoinModel asset;
  final VoidCallback onTap;
  const AssetItemCoin({Key? key, required this.asset, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(asset.tokenImageUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(asset.name),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.balance.toString(),
                ),
                Text('\u2248 \$100')
              ],
            )
          ],
        ),
      ),
    );
  }
}
