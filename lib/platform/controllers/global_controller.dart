import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class GlobalController extends SuperController {
  final Rx<ConnectivityResult> connectivityResult = Rx(ConnectivityResult.none);
  StreamSubscription<ConnectivityResult>? connectivityStream;

  @override
  void onInit() async {
    await getConnectivity();
    initConnectivityStream();
    super.onInit();
  }

  @override
  void onDetached() {
    connectivityStream?.cancel();
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    connectivityStream?.cancel();
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() async {
    await getConnectivity();
    initConnectivityStream();
  }

  Future<void> getConnectivity() async {
    connectivityResult.value = await (Connectivity().checkConnectivity());
  }

  void initConnectivityStream() {
    connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityResult.value = result;
    });
  }
}
