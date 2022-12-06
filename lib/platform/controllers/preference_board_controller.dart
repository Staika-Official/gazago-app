import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:get/get.dart';

class PreferenceBoardController extends GetxController {
  RxString boardType = RxString('');
  RxList<TermItemModel> boardList = RxList.empty();
  Rx<TermItemModel> noticeDetail = Rx(
    TermItemModel(
      id: -1,
      title: '',
      content: '',
      createdDate: '',
    ),
  );
  RxString get boardName {
    if (boardType.value == 'T2E_NOTICE') {
      return RxString('공지사항');
    } else {
      return RxString('FAQ');
    }
  }

  @override
  void onInit() {
    boardType.value = Get.arguments['boardType'];
    getPostList();
    super.onInit();
  }

  void getPostList() async {
    await BoardService.getPostListByType(boardType.value, successCallback: (List<TermItemModel> terms) {
      boardList.value = terms;
    });
  }

  void moveNoticeDetail(id) {
    noticeDetail.value = boardList.firstWhere((element) => id == element.id);
    Get.toNamed(Routes.noticeDetail, arguments: {'id': id!});
  }

  void toggleExpansion(TermItemModel termItem, bool state) {
    List<TermItemModel> termsList = boardList;
    boardList.value = termsList.map((term) {
      if (term == termItem) {
        term.isChecked = state;
      }
      return term;
    }).toList();
  }
}
