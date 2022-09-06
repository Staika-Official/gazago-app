import 'package:get/get.dart';
import 'package:step_go/platform/models/term_item_model.dart';

class JoinTermsController extends GetxController {
  RxList<TermItemModel> termsList = RxList.empty();

  @override
  void onInit() {
    getTermsList();
    super.onInit();
  }

  void getTermsList() {
    termsList.value = [
      TermItemModel(title: '이용약관 동의', isChecked: false, isRequired: true),
      TermItemModel(title: '개인정보 수집 및 이용 동의', isChecked: false, isRequired: true),
      TermItemModel(title: '위치정보 이용 동의', isChecked: false, isRequired: true),
      TermItemModel(title: '마케팅 정보 수신 동의', isChecked: false, isRequired: false),
    ];
  }

  void toggleTerm(TermItemModel termItem) {}
}
