import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final RxInt _current = 0.obs;
  late final int pageSize;
  RxList<double> ops = [1.0, 0.0, 0.0].obs;
  RxList<double> offsets = [0.0, 0.0, 0.0].obs;

  OnBoardingController() {
    pageSize = imgList.length;
  }

  final List<Map<String, String>> _content = [
    {'title': '가자고! 산으로', 'content': '대한민국 명산 중 원하는 코스를 골라\n도전하고 뱃지를 보상으로 받아요'},
    {'title': '받자고! 혜택을', 'content': '빠아침 햇살 내린 동네 앞길을 산책하면\n어느덧 토큰으로 보상이 쌓여요'},
    {'title': '만나자고! 다함께', 'content': '몸과 마음 그리고 혜택까지 챙겨주는 가자고를\n친구, 가족, 그리고 연인과 함께 가자고!'}
  ];

  final List<Map<String, dynamic>> imgList = [
    {
      'path': 'assets/images/common/img_onboarding_01.png',
    },
    {
      'path': 'assets/images/common/img_onboarding_02.png',
    },
    {
      'path': 'assets/images/common/img_onboarding_03.png',
    },
  ];

  Map getText(int index) {
    return _content[index];
  }

  setValue(double op) {
    if (op > 0 && op < 1) {
      ops[0] = 1 - op;
      ops[1] = op;
    } else if (op > 1 && op < 2) {
      ops[1] = 2 - op;
      ops[2] = -1 + op;
    }

    if (op == 0.0) {
      ops[0] = 1;
      ops[1] = ops[2] = 0;
    } else if (op == 1.0) {
      ops[1] = 1;
      ops[0] = ops[2] = 0;
    } else if (op == 2.0) {
      ops[2] = 1;
      ops[0] = ops[1] = 0;
    }
  }

  setCurrent(int index) {
    _current.value = index;
  }

  get current => _current;

  void nextStep() {
    Get.toNamed(Routes.joinTerms);
  }
}
