import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class TermController extends GetxController {
  final RxString platform = RxString('');
  final RxString termType = RxString('');
  final RxInt termId = RxInt(0);
  final RxString termTitle = RxString('');
  final RxString termContent = RxString('');
  final RxBool agreeMarketing = RxBool(false);

  @override
  void onInit() async {
    print(Get.arguments['platform']);
    platform.value = Get.arguments['platform'] ?? 'gazago';
    termType.value = Get.arguments['termType'] ?? '';
    termId.value = Get.arguments['termId'] ?? 0;
    if (termType.value == 'MARKETING' && Get.previousRoute != Routes.joinTerms){
      initMarketingAgreeStatus();
    }

    await getTermInfo();
    super.onInit();
  }

  Future<void> getTermInfo() async {
    await BoardService.getPostListByType(termType.value, platform: platform.value, successCallback: (List<TermItemModel> termItems) {
      termTitle.value = termItems.first.title!;
      termContent.value = termItems.first.content!;
      termId.value = termItems.first.id!;
      termType.value = termItems.first.boardType!;
    });
  }

  void initMarketingAgreeStatus() async {
    await MemberService.getMemberUserInfo(
      clientId: platform.value.toUpperCase(),
      successCallback: (memberUserModel) {
        agreeMarketing.value = memberUserModel.marketingChecked;
        HiveStore.save(key: HiveKey.profileImageUrl.name, value: memberUserModel.profileImageUrl);
        HiveStore.save(key: HiveKey.nickname.name, value: memberUserModel.nickname);
      },
      errorCallback: (message) {
        showToastPopup(message);
      },
    );
  }

  void toggleSwitch(val, {Function(String)? error}) async {
    agreeMarketing.value = val;
    await MemberService.fetchTermsAgree([TermsHistoryModel(terms: termTitle.value, postId: termId.value, boardType: termType.value, activated: val, clientId: platform.value.toUpperCase())],
        successCallback: (effectedCount) async {
      if (agreeMarketing.value) {
        showToastPopup('마케팅 정보 수신 동의를 하였습니다.');
      } else {
        showToastPopup('마케팅 정보 수신 동의를 철회하였습니다.');
      }
    }, errorCallback: () {
      showToastPopup('마케팅 정보 수신 동의를 실패');
      agreeMarketing.value = !val;
    });
    // await _termsUseCase.agreeJoinTerms([TermsHistoryModel(terms: term.value.title, postId: term.value.id, activated: val, boardType: term.value.boardType)], error: error);
  }
}
