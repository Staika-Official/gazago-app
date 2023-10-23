import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectionNoticeController extends GetxController {
  RxBool isShowNoticeWebview = RxBool(false);

  @override
  void onInit() async {
    await checkInspectionNotice();
    super.onInit();
  }

  @override
  void onResumed() async {
    print('onResumed InspectionNoticeController');
    await checkInspectionNotice();
  }

  Future<void> checkInspectionNotice() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    bool isInspectionNotice = await getConfig(dataType: ConfigType.bool, configKey: 'notice_alert');
    if (isInspectionNotice) {
      print('123123123123123123123');
      forceLogout();
      return;
    } else {}
  }
}
