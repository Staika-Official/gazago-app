import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:get/get.dart';

class TermController extends GetxController {
  final RxString termType = RxString('');
  final RxInt termId = RxInt(0);
  final RxString termTitle = RxString('');
  final RxString termContent = RxString('');
  final RxBool agreeMarketing = RxBool(false);

  @override
  void onInit() async {
    termType.value = Get.arguments['termType'] ?? '';
    termId.value = Get.arguments['termId'] ?? 0;
    // await initMarketingAgreeStatus();
    await getTermInfo();
    super.onInit();
  }

  Future<void> getTermInfo() async {
    await BoardService.getFirstPostByType(termType.value, successCallback: (List<TermItemModel> termItems) {
      termTitle.value = termItems.first.title!;
      termContent.value = termItems.first.content!;
      termId.value = termItems.first.id!;
      termType.value = termItems.first.boardType!;
    });
  }

  // void initMarketingAgreeStatus() async {
  //   MemberUserModel userModel = await _memberUseCase.getMemberUserInfo();
  //   agreeMarketing.value = userModel.marketingChecked;
  // }

  void toggleSwitch(val, {Function(String)? error}) async {
    agreeMarketing.value = val;
    await MemberService.fetchTermsAgree(
      TermsHistoryModel(terms: termTitle.value, postId: termId.value, boardType: termType.value, activated: val),
      successCallback: (effectedCount) async {
        if (effectedCount == 0) {
          showToastPopup('마케팅 정보 수신 동의를 철회하였습니다.');
        } else {
          showToastPopup('마케팅 정보 수신 동의를 하였습니다.');
        }
      },
    );
    // await _termsUseCase.agreeJoinTerms([TermsHistoryModel(terms: term.value.title, postId: term.value.id, activated: val, boardType: term.value.boardType)], error: error);
  }
}
