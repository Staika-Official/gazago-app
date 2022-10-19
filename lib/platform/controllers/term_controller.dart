import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:get/get.dart';

class TermController extends GetxController {
  final RxString termType = RxString('');
  final RxInt termId = RxInt(0);
  final RxString termTitle = RxString('');
  final RxString termContent = RxString('');

  @override
  void onInit() async {
    termType.value = Get.arguments['termType'] ?? '';
    termId.value = Get.arguments['termId'] ?? 0;
    await getTermInfo();
    super.onInit();
  }

  Future<void> getTermInfo() async {
    await BoardService.getPostById(termId.value, successCallback: (TermItemModel termItem) {
      termTitle.value = termItem.title!;
      termContent.value = termItem.content!;
    });
  }
}
