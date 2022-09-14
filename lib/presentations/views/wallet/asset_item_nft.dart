import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:step_go/platform/models/asset_item_nft_model.dart';

class AssetItemNft extends StatelessWidget {
  final AssetItemNftModel asset;
  final VoidCallback onTap;
  const AssetItemNft({Key? key, required this.asset, required this.onTap}) : super(key: key);

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
            Text(
              '${asset.balance.toString()} NFT',
            ),
          ],
        ),
      ),
    );
  }
}
