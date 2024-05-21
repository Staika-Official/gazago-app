import 'package:firebase_database/firebase_database.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectionNoticeController extends GetxController {
  @override
  void onInit() async {
    await checkInspectionNotice();
    super.onInit();
  }

  void getStreamData(snapshot) async {
    if (snapshot.value == true) {
      forceLogout();
      if (Get.currentRoute == Routes.login && !Get.isBottomSheetOpen!) {
        String noticeUri = getConfig(dataType: ConfigType.string, configKey: 'notice_alert_address');
        Uri url = Uri.parse(noticeUri);
        if (await canLaunchUrl(url)) {
          showModalNoticeWebview(Get.context, linkUrl: noticeUri);
        }
      }
      return;
    } else {
      if (Get.currentRoute == Routes.login && Get.isBottomSheetOpen!) {
        Get.back();
      }
    }
  }

  Future<void> checkInspectionNotice() async {
    DatabaseReference inspectionNoticeRef = FirebaseDatabase.instance.ref('inspectionNotice');
    Stream<DatabaseEvent> stream = inspectionNoticeRef.onValue;
    await inspectionNoticeRef.get().then((DataSnapshot snapshot) async {
      getStreamData(snapshot);
    }).onError((error, stackTrace) {});
    stream.listen((DatabaseEvent event) {
      getStreamData(event.snapshot);
    });
  }
}
