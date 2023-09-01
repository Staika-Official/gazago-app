import 'package:flutter/material.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/crew_member_model.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class CrewDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  late TabController tabController;
  Rxn<CrewModel> selectedCrew = Rxn();
  RxInt crewRanking = RxInt(0);
  RxList<CrewMemberModel> get crewLeaderboardList {
    return RxList(selectedCrew.value!.crewMemberList!);
  }

  RxInt crewTabIndex = RxInt(0);
  RxInt get accumulatedCrewInvite {
    if (selectedCrew.value == null) return RxInt(0);
    return RxInt(selectedCrew.value!.crewMemberList!.fold(0, (prevValue, element) => prevValue + element.inviteCount!));
  }

  RxInt get accumulatedCrewBlock {
    if (selectedCrew.value == null) return RxInt(0);
    return RxInt(selectedCrew.value!.crewMemberList!.fold(0, (prevValue, element) => prevValue + element.blockQuantity!));
  }

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 1) {}
      });
    crewRanking.value = await Get.arguments['ranking'];
    selectedCrew.value = await Get.arguments['crew'];
    tabController.addListener(_tabController);
    showRelayEndedAlert();

    super.onInit();
  }

  Future<void> refreshController() async {}

  void _tabController() {
    crewTabIndex.value = tabController.index;
  }

  Future<void> validateRecruitLock() async {
    if (selectedCrew.value!.crewRecruitStatus == 'OPEN') {
      crewRecruitLimitAlert(this);
    } else {
      crewRecruitUnlimitAlert(this);
    }
  }

  Future<void> toggleRecruitLimit() async {
    selectedCrew.update((state) {
      state!.crewRecruitStatus = selectedCrew.value!.crewRecruitStatus! == 'OPEN' ? 'CLOSE' : 'OPEN';
    });
  }

  void showRelayEndedAlert() {
    if (selectedCrew.value!.crewRelayStatus! == "ENDED") {
      showCrewRelayEndedAlert();
    }
  }
}
