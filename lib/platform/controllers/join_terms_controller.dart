import 'package:get/get.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';

class JoinTermsController extends GetxController {
  final RxList<TermItemModel> termsList = RxList.empty();
  final RxBool allAgreed = RxBool(false);

  @override
  void onInit() {
    getTermsList();
    super.onInit();
  }

  void getTermsList() {
    termsList.value = [
      TermItemModel(title: '이용약관 동의', termType: 'TERM', isChecked: false, isRequired: true),
      TermItemModel(title: '개인정보 수집 및 이용 동의', termType: 'PRIVACY', isChecked: false, isRequired: true),
      TermItemModel(title: '위치정보 이용 동의', termType: 'LOCATION', isChecked: false, isRequired: true),
      TermItemModel(title: '마케팅 정보 수신 동의', termType: 'MARKETING', isChecked: false, isRequired: false),
    ];
  }

  void toggleTerm(TermItemModel termItem) {
    List<TermItemModel> termsList = this.termsList;
    this.termsList.value = termsList.map((term) {
      if (term == termItem) {
        term.isChecked = !termItem.isChecked;
      }
      return term;
    }).toList();
    allAgreed.value = termsList.every((term) => term.isChecked);
  }

  void toggleAllTerms() {
    List<TermItemModel> termsList = this.termsList;
    this.termsList.value = termsList.map((term) {
      term.isChecked = !allAgreed.value;
      return term;
    }).toList();
    allAgreed.value = !allAgreed.value;
  }
}
