import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';

class AssetItemNft extends StatelessWidget {
  final AssetItemNftModel asset;
  final VoidCallback onTap;
  const AssetItemNft({super.key, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Row(
          children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(
                asset.tokenImageUrl,
                headers: imageNetworkHeader,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0.sp),
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
