import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class NoticePopupController extends GetxController {
  GlobalController globalController = Get.find();
  RxList<NoticePopupModel> noticePopupList = RxList.empty();
  final RxInt _current = 0.obs;
  late final int pageSize;
  RxList<double> ops = [1.0, 0.0, 0.0].obs;
  RxList<double> offsets = [0.0, 0.0, 0.0].obs;

  @override
  void onInit() async {
    // HiveStore.save(key: HiveKey.closePopupDate.name, value: null);
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
    checkPopupExpired();
  }

  Future<void> getNoticePopupList() async {
    await BoardService.getNoticePopupList(
      successCallback: (records) {
        noticePopupList.addAll(records);
      },
    );
  }

  void moveToWebView(item) {
    if (item.linkUrl.contains('http')) {
      Get.toNamed(Routes.webView, arguments: {'id': item.id, 'linkUrl': item.linkUrl});
    } else {
      switch (item.linkUrl) {
        case 'ARCHIVE':
          Get.back();
          Get.find<HomeMenuController>().selectMenu(0);
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
        case 'WALLET':
          Get.toNamed(Routes.wallet);
          break;
        case 'NOTICE':
          Get.toNamed(Routes.noticeList);
          break;
        case 'FAQ':
          Get.toNamed(Routes.preferenceBoard);
          break;
      }
    }
  }

  void checkPopupExpired() {
    // HiveStore.save(key: HiveKey.closePopupDate.name, value: null);
    if (globalController.isPopupOpen.value && noticePopupList.isNotEmpty) {
      setCurrent(0);
      showMainPopupAlert(this);
    }
  }

  void onSavePopupCloseDate() {
    DateTime now = DateTime.now();
    HiveStore.save(key: HiveKey.closePopupDate.name, value: now);
    Get.back();
  }
}
