import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/crew_member_model.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/services/crew_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class CrewDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  late TabController tabController;
  Rxn<CrewModel> selectedCrew = Rxn();
  RxInt crewRanking = RxInt(0);
  RxInt dailyBlockCount = RxInt(0);
  RxList<CrewMemberModel> get crewLeaderboardList {
    return selectedCrew.value != null ? RxList(selectedCrew.value!.crewMemberList!) : RxList.empty();
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

  RxBool get isFounder {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    return selectedCrew.value != null ? RxBool(selectedCrew.value!.crewFounderId.toString() == userId) : RxBool(false);
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
    await getDailyBlockCount();
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

  void showRelayEndedAlert() {
    Future.delayed(const Duration(seconds: 1));
    if (selectedCrew.value!.crewRelayStatus! == "ENDED") {
      showCrewRelayEndedAlert(this);
    }
  }

  Future<void> requestToggleRecruitStatus() async {
    await CrewService.changeRecruitStatus(
      selectedCrew.value!.id!,
      selectedCrew.value!.crewRecruitStatus! == 'OPEN' ? 'CLOSE' : 'OPEN',
      successCallback: () {
        selectedCrew.value!.crewRecruitStatus! == 'OPEN' ? showToastPopup('크루 모집이 제한되었습니다.') : showToastPopup('크루 모집 중 입니다.');

        selectedCrew.update((state) {
          state!.crewRecruitStatus = selectedCrew.value!.crewRecruitStatus! == 'OPEN' ? 'CLOSE' : 'OPEN';
        });
      },
      errorCallback: (ErrorResponseDataModel error) {
        if (error.errorCode == 'NOT_AVAILABLE_RECRUIT_OPEN') {
          crewRecruitToggleLimitErrorAlert(error.errorMessage!);
        } else {
          showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
        }
      },
    );
  }

  Future<void> getDailyBlockCount() async {
    await CrewService.getDailyBlockCount(
      selectedCrew.value!.id!,
      successCallback: (data) {
        if (data['dailyCrewBlockQuantity'] != null) dailyBlockCount.value = data['dailyCrewBlockQuantity'];
      },
    );
  }
}
