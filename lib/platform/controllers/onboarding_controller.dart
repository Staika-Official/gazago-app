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
    {'title': 'Decentalized\nAssets,', 'content': '쉽고 간편한 회원가입'},
    {'title': 'Integrated\nManagement,', 'content': '빠르고 안전한 디지털 자산 송금'},
    {'title': 'Staika focuses\non these problems,', 'content': '편안한 마음 편안한 디지털 자산 관리'}
  ];

  final List<Map<String, dynamic>> imgList = [
    {
      'path': 'assets/images/onboarding_1.png',
      'height': 250.0,
    },
    {
      'path': 'assets/images/onboarding_2.png',
      'height': 310.0,
    },
    {
      'path': 'assets/images/onboarding_3.png',
      'height': 275.0,
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
