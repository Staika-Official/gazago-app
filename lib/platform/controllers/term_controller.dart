import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
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
    });
  }

  // void initMarketingAgreeStatus() async {
  //   MemberUserModel userModel = await _memberUseCase.getMemberUserInfo();
  //   agreeMarketing.value = userModel.marketingChecked;
  // }

  void toggleSwitch(val, {Function(String)? error}) async {
    agreeMarketing.value = val;
    // await _termsUseCase.agreeJoinTerms([TermsHistoryModel(terms: term.value.title, postId: term.value.id, activated: val, boardType: term.value.boardType)], error: error);
  }
}
