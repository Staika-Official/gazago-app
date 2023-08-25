import 'package:flutter/material.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:get/get.dart';

class CrewDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  late TabController tabController;
  RxInt crewTabIndex = RxInt(0);

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 1) {}
      });
    tabController.addListener(_tabController);

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshController() async {}

  void _tabController() {
    crewTabIndex.value = tabController.index;
  }
}
