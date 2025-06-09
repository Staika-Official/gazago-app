import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class WithdrawConfirmController extends GetxController {
  final RxList<TermItemModel> withdrawCheckList = RxList.empty();
  final RxBool allAgreed = RxBool(false);

  @override
  void onInit() {
    getWithdrawCheckList();
    super.onInit();
  }

  void getWithdrawCheckList() {
    withdrawCheckList.value = [
      TermItemModel(
        title: 'unsettled_go_expire'.tr(),
        isChecked: false,
      ),
      TermItemModel(
        title: 'all_data_deleted'.tr(),
        isChecked: false,
      ),
      TermItemModel(
        title: 'data_irrecoverable'.tr(),
        isChecked: false,
      ),
      TermItemModel(
        title: 'unused_items_expire'.tr(),
        isChecked: false,
      ),
    ];
  }

  void toggleCheckList(TermItemModel termItem) {
    List<TermItemModel> withdrawCheckList = this.withdrawCheckList;
    this.withdrawCheckList.value = withdrawCheckList.map((term) {
      if (term == termItem) {
        term.isChecked = !termItem.isChecked;
      }
      return term;
    }).toList();
    allAgreed.value = withdrawCheckList.every((term) => term.isChecked);
  }

  void toggleAllTerms() {
    List<TermItemModel> withdrawCheckList = this.withdrawCheckList;
    this.withdrawCheckList.value = withdrawCheckList.map((term) {
      term.isChecked = !allAgreed.value;
      return term;
    }).toList();
    allAgreed.value = !allAgreed.value;
  }

  void showWithdrawConfirmPopup() {
    showConfirmWithdrawAlert(this);
  }

  void handleFetchWithdrawMember() async {
    await UaaService.fetchWithdrawMember(
      successCallback: () {
        Get.toNamed(Routes.withdrawCompleted);
      },
      errorCallback: (ErrorResponseDataModel? errorData) {
        showToastPopup(errorData!.errorMessage!);
      },
    );
    // Get.toNamed(Routes.withdrawCompleted)
  }

  void handleWithdrawComplete() {
    // HiveStore.deleteMultipleKeys(keys: [
    //   HiveKey.uuid.name,
    // ]);
    forceLogout();
  }
}
