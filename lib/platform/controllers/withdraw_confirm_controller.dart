import 'package:get/get.dart';
import 'package:step_go/platform/models/term_item_model.dart';

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
      TermItemModel(title: '정산되지 않은 GO는 소멸됩니다.', termType: '', isChecked: false, isRequired: true),
      TermItemModel(title: '모든 운동 기록과 개인 정보는 삭제됩니다.', termType: '', isChecked: false, isRequired: true),
      TermItemModel(title: '코인, 지갑, 거래 내역 등을 복구할 수 없습니다.', termType: '', isChecked: false, isRequired: true),
      TermItemModel(title: '외부 지갑으로 전송하지 않은 뱃지 NFT와 신발, 모자, 옷 등의 아이템은 소멸됩니다.', termType: '', isChecked: false, isRequired: true),
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
}
