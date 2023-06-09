import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticePopupController extends GetxController {
  GlobalController globalController = Get.find();
  RxList<NoticePopupModel> noticePopupList = RxList.empty();
  RxList<NoticePopupModel> noticeMainPopupList = RxList.empty();
  final RxInt _current = 0.obs;
  late final int pageSize;
  RxList<double> ops = [1.0, 0.0, 0.0].obs;
  RxList<double> offsets = [0.0, 0.0, 0.0].obs;
  RxBool hasNewNotice = RxBool(false);

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  setValue(double op) {
    if (op > 0 && op < 1) {
      ops[0] = 1 - op;
      ops[1] = op;
    } else if (op > 1 && op < 2) {
      ops[1] = 2 - op;
      ops[2] = -1 + op;
    }

    if (op == 0.0) {
      ops[0] = 1;
      ops[1] = ops[2] = 0;
    } else if (op == 1.0) {
      ops[1] = 1;
      ops[0] = ops[2] = 0;
    } else if (op == 2.0) {
      ops[2] = 1;
      ops[0] = ops[1] = 0;
    }
  }

  RxInt get current => _current;

  setCurrent(int index) {
    _current.value = index;
  }

  Future<void> initController() async {
    await getNoticePopupList();
    await getMainNoticePopupList();
    checkPopupExpired();
  }

  Future<void> getMainNoticePopupList() async {
    await BoardService.getMainNoticePopupList(
      successCallback: (List<NoticePopupModel> records) {
        records.removeWhere((element) => element.type == 'INSPECTION');
        noticeMainPopupList.addAll(records);
      },
    );
  }

  Future<void> getNoticePopupList() async {
    await BoardService.getNoticePopupList(
      successCallback: (List<NoticePopupModel> records) {
        records.removeWhere((element) => element.type == 'INSPECTION');
        noticePopupList.addAll(records);
        List<int>? noticePopupListIds = HiveStore.load(key: HiveKey.noticePopupListIds.name);
        if (noticePopupListIds != null && noticePopupListIds.isNotEmpty) {
          for (NoticePopupModel notice in noticePopupList) {
            if (!noticePopupListIds.contains(notice.id!)) {
              hasNewNotice.value = true;
              break;
            }
          }
        } else if (noticePopupListIds == null && noticePopupList.isNotEmpty) {
          hasNewNotice.value = true;
        }
      },
    );
  }

  void moveToWebView(NoticePopupModel item) async {
    switch (item.openType) {
      case 'IN_APP':
        switch (item.linkUrl) {
          case 'CHALLENGES':
            Get.back();
            Get.find<HomeMenuController>().selectMenu(0);
            break;
          case 'ARCHIVE':
            Get.back();
            Get.find<HomeMenuController>().selectMenu(4);
            break;
          case 'ITEM':
            Get.back();
            Get.find<HomeMenuController>().selectMenu(1);
            break;
          case 'SHOP':
            Get.back();
            Get.find<HomeMenuController>().selectMenu(3);
            break;
          case 'RANKING':
            Get.back();
            Get.find<HomeMenuController>().selectMenu(4);
            break;
            break;
          case 'WALLET':
            Get.toNamed(Routes.wallet);
            break;
          case 'NOTICE':
            // Get.toNamed(Routes.noticeList);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/c5103042de5d4e3a9a61c1101508ffed'});
            break;
          case 'FAQ':
            // Get.toNamed(Routes.preferenceBoard);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/FAQ-2f6b0ec4d6134fd398cd7a832bfa6cd3'});
            break;
        }
        break;
      case 'INTERNAL_WEB_VIEW':
        Get.toNamed(Routes.webView, arguments: {'id': item.id, 'linkUrl': item.linkUrl});
        break;
      case 'EXTERNAL_BROWSER':
        Uri url = Uri.parse(item.linkUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }

  void checkPopupExpired() {
    if (globalController.isPopupOpen.value && noticeMainPopupList.isNotEmpty) {
      setCurrent(0);
      showMainPopupAlert(this);
    }
  }

  void onSavePopupCloseDate() {
    DateTime now = DateTime.now();
    HiveStore.save(key: HiveKey.closePopupDate.name, value: now);
    Get.back();
  }

  void moveToNotificationsListPage() {
    List<int> noticePopupListIds = noticePopupList.map((element) => element.id!).toSet().toList();
    HiveStore.save(key: HiveKey.noticePopupListIds.name, value: noticePopupListIds);
    hasNewNotice.value = false;
    Get.toNamed(Routes.notifications);
  }
}
