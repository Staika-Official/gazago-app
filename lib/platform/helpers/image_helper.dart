import 'dart:math';
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImageHelper {
  /// Cache: key = "$assetName_${size.width}x${size.height}_$treasureId"
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    String assetName,
    Size size,
    int treasureId,
  ) async {
    final key =
        "${assetName}_${size.width.toInt()}x${size.height.toInt()}_$treasureId";

    if (_cache.containsKey(key)) {
      return _cache[key]!;
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

    // Save to cache
    _cache[key] = bitmap;

    return bitmap;
  }
}
