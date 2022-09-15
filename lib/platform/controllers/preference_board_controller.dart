import 'package:get/get.dart';
import 'package:step_go/platform/models/board_item_model.dart';

class PreferenceBoardController extends GetxController {
  RxString boardType = RxString('');
  RxList<BoardItemModel> boardList = RxList.empty();
  RxString get boardName {
    if (boardType.value == 'NOTICE') {
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

  void getPostList() {
    boardList.value = [
      BoardItemModel(id: 1, boardType: 'NOTICE', title: 'test', content: 'testset', lastModifiedDate: '20221023'),
      BoardItemModel(id: 1, boardType: 'NOTICE', title: 'test', content: 'testset', lastModifiedDate: '20221023'),
      BoardItemModel(id: 1, boardType: 'NOTICE', title: 'test', content: 'testset', lastModifiedDate: '20221023'),
      BoardItemModel(id: 1, boardType: 'NOTICE', title: 'test', content: 'testset', lastModifiedDate: '20221023'),
      BoardItemModel(id: 1, boardType: 'NOTICE', title: 'test', content: 'testset', lastModifiedDate: '20221023'),
    ];
  }
}
