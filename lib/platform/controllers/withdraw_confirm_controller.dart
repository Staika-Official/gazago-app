import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

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
        title: '정산되지 않은 GO는 소멸됩니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '모든 운동 기록과 개인 정보는 삭제됩니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '코인, 지갑, 거래 내역 등을 복구할 수 없습니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '외부 지갑으로 전송하지 않은 뱃지 NFT와 신발, 모자, 옷 등의 아이템은 소멸됩니다.',
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
    HiveStore.deleteMultipleKeys(keys: [
      HiveKey.uuid.name,
    ]);
    forceLogout();
  }
}
