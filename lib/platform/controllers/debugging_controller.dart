import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class DebuggingController extends GetxController {
  int doubleTouchCount = 0;
  RxBool isShowDebuggingMenu = RxBool(false);

  @override
  void onInit() async {
    isShowDebuggingMenu.value = HiveStore.load(key: HiveKey.isDebuggingMode.name);
    print('매ㅏ에매ㅏ레ㅐㅁㅈㅁㅇ${HiveStore.load(key: HiveKey.requestLogs.name)}');
    super.onInit();
  }

  void onDebuggingModeTouchCount() async {
    doubleTouchCount++;
    if (doubleTouchCount > 4) {
      isShowDebuggingMenu.value = true;
      HiveStore.save(key: HiveKey.isShowDebuggingMenu.name, value: true);
      HiveStore.save(key: HiveKey.isDebuggingMode.name, value: true);
      doubleTouchCount = 0;
    }
  }

  void onDisableDebuggingMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: true);
  }

  void onEnableDebuggingMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: false);
  }

  void handleInitLogs(String key) {
    List logs = [];
    HiveStore.save(key: HiveKey.requestLogs.name, value: logs);
  }
}
