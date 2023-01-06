import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:get/get.dart';

class VerificationTermsController extends GetxController {
  final RxList<TermItemModel> termsList = RxList.empty();
  final RxBool isCompleteCertification = RxBool(false);
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
    await BoardService.getFirstPostByType('IDENTITY_A,IDENTITY_B,IDENTITY_C,IDENTITY_D,IDENTITY_E', successCallback: (List<TermItemModel> terms) {
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

  void nextStep() {
    if (allAgreed.value) {
      Get.toNamed(Routes.verificationName);
    } else {
      showToastPopup('필수 약관에 동의해주세요');
    }
  }
}
