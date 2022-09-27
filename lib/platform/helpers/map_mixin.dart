import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class MapMixin {
  void onMapCreated(NaverMapController controller, Completer<NaverMapController> mapCompleter) {
    if (mapCompleter.isCompleted) mapCompleter = Completer();
    mapCompleter.complete(controller);
  }

  onMapTap(LatLng position) async {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapLongTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapDoubleTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapTwoFingerTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onSymbolTap(LatLng? position, String? caption) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onSymbolTap] caption: $caption, lat: ${position!.latitude}, lon: ${position!.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  void onCameraChange(LatLng? latLng, CameraChangeReason? reason, bool? isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng!.latitude}, ${latLng!.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void onCameraIdle() {
    print('카메라 움직임 멈춤');
  }
}
