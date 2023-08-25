import 'package:flutter/material.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:get/get.dart';

class CrewDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  late TabController tabController;
  RxList<CrewModel> crewLeaderboardList = RxList.empty();
  RxInt crewTabIndex = RxInt(0);

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 1) {}
      });
    tabController.addListener(_tabController);
    getCrewLeaderboardList();
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

  Future<void> getCrewLeaderboardList() async {
    crewLeaderboardList.value = [
      CrewModel(name: "크루명01", crewFounderNickName: "크루장01", iconImageUrl: "assets/images/@temp_badge.png", rank: 1, blockQuantity: 100),
      CrewModel(name: "크루명01", crewFounderNickName: "크루장01", iconImageUrl: "assets/images/@temp_badge.png", rank: 2, blockQuantity: 100),
      CrewModel(name: "크루명01", crewFounderNickName: "크루장01", iconImageUrl: "assets/images/@temp_badge.png", rank: 3, blockQuantity: 100),
      CrewModel(name: "크루명01", crewFounderNickName: "크루장01", iconImageUrl: "assets/images/@temp_badge.png", rank: 4, blockQuantity: 100),
      CrewModel(name: "크루명01", crewFounderNickName: "크루장01", iconImageUrl: "assets/images/@temp_badge.png", rank: 5, blockQuantity: 10),
    ];
  }
}
