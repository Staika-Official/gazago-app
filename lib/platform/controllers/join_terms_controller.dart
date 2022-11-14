import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:get/get.dart';

class JoinTermsController extends GetxController {
  final RxList<TermItemModel> termsList = RxList.empty();
  RxBool get allAgreed {
    return RxBool(termsList.every((term) => term.isChecked == true));
  }

  RxBool get allRequiredAgreed {
    return RxBool(termsList.where((term) => term.isRequired == true).every((term) => term.isChecked == true));
  }

  @override
  void onInit() {
    getTermsList();
    super.onInit();
  }

  void getTermsList() async {
    await BoardService.getFirstPostByType('T2E_TERMS,T2E_PRIVACY,T2E_LOCATION,T2E_MARKETING', successCallback: (List<TermItemModel> terms) {
      termsList.value = terms;
    });
  }

  void toggleTerm(TermItemModel termItem) {
    List<TermItemModel> termsList = this.termsList;
    this.termsList.value = termsList.map((term) {
      if (term == termItem) {
        term.isChecked = !termItem.isChecked;
      }
      return term;
    }).toList();
  }

  void toggleAllTerms() {
    List<TermItemModel> termsList = this.termsList;
    bool allChecked = !allAgreed.value;
    this.termsList.value = termsList.map((term) {
      term.isChecked = allChecked;
      return term;
    }).toList();
  }

  void requestJoin() {
    if (allRequiredAgreed.value) {
      Get.toNamed(Routes.permissions);
    } else {
      showToastPopup('필수 약관에 동의해주세요');
    }
  }
}
