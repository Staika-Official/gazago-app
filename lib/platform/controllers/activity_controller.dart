import 'package:get/get.dart';
import 'package:gaza_go/platform/models/stat_model.dart';

class ActivityController extends GetxController {
  final RxList<StatModel> statList = RxList.empty();
  final RxInt stepCount = RxInt(0);
  RxList<Map> get activitySumList {
    return RxList([
      {'title': '총 운동 시간', 'content': '1일 ${'03:15:12'}'},
      {'title': '총 운동 거리', 'content': '${300.34.toString()} km'},
      {'title': '총 걸음 수', 'content': '${stepCount.value.toString()}'},
      {'title': '총 획득 Taika', 'content': '${200.toString()}'},
    ]);
  }

  @override
  void onInit() {
    initStats();
    super.onInit();
  }

  void initStats() {
    statList.value = [
      StatModel(name: '체력', currentStat: 78),
      StatModel(name: '내구도', currentStat: 55),
    ];
  }
}
