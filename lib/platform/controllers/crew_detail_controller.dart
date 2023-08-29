import 'package:flutter/material.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:get/get.dart';

class CrewDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  late TabController tabController;
  Rxn<CrewModel> selectedCrew = Rxn();
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
    selectedCrew.value = CrewModel(name: "마이크루", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 1, blockQuantity: 100, isLocked: false, invitationCount: 1);
    crewLeaderboardList.value = [
      CrewModel(name: "크루01", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 1, blockQuantity: 100, isLocked: false, invitationCount: 1),
      CrewModel(name: "크루01", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 2, blockQuantity: 100, isLocked: false, invitationCount: 1),
      CrewModel(name: "크루04", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 3, blockQuantity: 100, isLocked: false, invitationCount: 4),
      CrewModel(name: "크루03", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 4, blockQuantity: 100, isLocked: true, invitationCount: 0),
      CrewModel(name: "크루02", crewFounderNickName: "크루장01", iconImageUrl: "", rank: 5, blockQuantity: 10, isLocked: true, invitationCount: 1),
    ];
  }
}
