import 'dart:math';
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImageHelper {
  static final Map<String, BitmapDescriptor> _cachedImages = {};

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    String assetName,
    Size size,
  ) async {
    final cacheKey = '${assetName}_${size.width}x${size.height}';

    if (_cachedImages.containsKey(cacheKey)) {
      return _cachedImages[cacheKey]!;
    }

    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    double devicePixelRatio =
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = PictureRecorder();

    Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ImageByteFormat.png))!;

    final bitmap = BitmapDescriptor.bytes(bytes.buffer.asUint8List());

    _cachedImages[cacheKey] = bitmap;

    return bitmap;
  }
}
