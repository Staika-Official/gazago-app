import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class OnBoardingController extends GetxController {
  final RxInt _current = 0.obs;
  late final int pageSize;
  RxList<double> ops = [1.0, 0.0, 0.0].obs;
  RxList<double> offsets = [0.0, 0.0, 0.0].obs;

  OnBoardingController() {
    pageSize = imgList.length;
  }

  final List<Map<String, String>> _content = [
    {
      'title': 'gazago_mountain'.tr(),
      'content': 'mountain_challenge_description'.tr()
    },
    {
      'title': 'gazago_benefits'.tr(),
      'content': 'walking_reward_description'.tr()
    },
    {'title': 'gazago_together'.tr(), 'content': 'gazago_with_friends'.tr()}
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
    Get.toNamed(Routes.joinTerms, arguments: {'platform': 'gazago'});
  }
}
