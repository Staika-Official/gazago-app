import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengesDetailController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey backgroundKey = GlobalKey();
  final RxDouble backgroundBoxSize = RxDouble(0.0);
  ScrollController challengeDetailScrollController = ScrollController();
  RxBool isHeightCalculated = RxBool(false);

  final List<Map<String, dynamic>> challengeList = [
    {
      'title': '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
      'openDate': '2023/02/01',
      'closeDate': '2023/02/28',
      'activityTypes': ['걷기', '100대 명산'],
      'challengeTypes': 'ITEM',
      'maxPeople': 100,
      'participatePeople': 80,
      'status': 'READY',
      'imageUrl': '',
      'userStatus': '참가중'
    },
  ];
  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    // _getSize(backgroundKey);
    // addListener(() {
    //   if (backgroundKey.currentContext != null) {
    //     backgroundBoxSize.value = backgroundKey.currentContext!.size!.height;
    //     print(backgroundKey.currentContext!.size!.height);
    //   }
    //   ;
    // });
    super.onInit();
  }

  @override
  void onReady() {
    // getSize();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getSize() {
    print('asdasdadsad');
    print(backgroundKey.currentContext);
    if (backgroundKey.currentContext != null) {
      print(backgroundKey.currentContext!.size!.height);
      backgroundBoxSize.value = backgroundKey.currentContext!.size!.height;
    }
  }

  // getSize() async {
  //   print('asdasdasdasdasd');
  //   print(backgroundKey.currentContext);
  //   print(backgroundKey.currentContext!.height);
  //   if (backgroundKey.currentContext != null) {
  //     final RenderBox renderBox = backgroundKey.currentContext!.findRenderObject() as RenderBox;
  //     print(backgroundKey.currentContext!.height);
  //     // return backgroundKey.currentContext;
  //     backgroundBoxSize.value = backgroundKey.currentContext!.height;
  //   }
  // }
}
