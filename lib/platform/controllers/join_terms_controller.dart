import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:get/get.dart';

class JoinTermsController extends GetxController {
  final RxString platform = RxString('');
  final RxList<TermItemModel> termsList = RxList.empty();
  RxBool get allAgreed {
    return RxBool(termsList.isNotEmpty ? termsList.every((term) => term.isChecked == true) : false);
  }

  RxBool get allRequiredAgreed {
    return RxBool(termsList.where((term) => term.isRequired == true).every((term) => term.isChecked == true));
  }

  @override
  void onInit() {
    platform.value = Get.arguments['platform'] ?? 'gazago';
    getTermsList();
    super.onInit();
  }

  void getTermsList() async {
    await BoardService.getPostListByType('TERMS,PRIVACY,LOCATION,MARKETING', platform: platform.value, successCallback: (List<TermItemModel> terms) {
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

  void requestJoin() async {
    if (allRequiredAgreed.value) {
      await MemberService.fetchTermsAgree(
          termsList.map((term) => TermsHistoryModel(terms: term.title!, postId: term.id!, activated: term.isChecked, boardType: term.boardType!, clientId: platform.value.toUpperCase())).toList(),
          successCallback: (effectedCount) async {
        if (effectedCount == termsList.length) {
          if (platform.value == 'gazago') {
            Get.toNamed(Routes.permissions);
          } else {
            Get.offNamed(Routes.createWalletPassword);
          }
        }
      }, errorCallback: () {
        showToastPopup('약관 동의에 실패하였습니다.');
      });
    } else {
      showToastPopup('필수 약관에 동의해주세요');
    }
  }
}
