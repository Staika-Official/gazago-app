import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
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
  @override
  void onInit() async {
    // await checkInspectionNotice();
    super.onInit();
  }

  @override
  void onResumed() async {
    print('onResumed InspectionNoticeController');

  }

  void getStreamData(snapshot) async {

    if(snapshot.value == true){
      forceLogout();
      if(Get.currentRoute == Routes.login && !Get.isBottomSheetOpen!){
        String noticeUri = getConfig(dataType: ConfigType.string, configKey: 'notice_alert_address');
        Uri url = Uri.parse(noticeUri);
        if (await canLaunchUrl(url)) {
          showModalNoticeWebview( linkUrl: noticeUri);
        }
      }
      return;
    } else {
      if(Get.currentRoute == Routes.login && Get.isBottomSheetOpen!){
        Get.back();
      }
    }
  }

  Future<void> checkInspectionNotice() async {
    DatabaseReference inspectionNoticeRef = FirebaseDatabase.instance.ref('inspectionNotice');
    Stream<DatabaseEvent> stream = inspectionNoticeRef.onValue;
    await inspectionNoticeRef.get().then((DataSnapshot snapshot) async {
      getStreamData(snapshot);
      }).onError((error, stackTrace) {
        print(error);
      });
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}');
      print('Snapshot: ${event.snapshot.value}');
      getStreamData(event.snapshot);
    });
  }
}
