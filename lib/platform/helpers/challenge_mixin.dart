import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ChallengeMixin {
  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<ChallengeModel> doableChallenges = RxList.empty();
  final RxList<ChallengeModel> achievableChallenges = RxList.empty();

  Future<void> getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  Future<void> getNearByChallengeList(LocationData currentLocation) async {
    challengeList.value = await ActivityService.getNearByChallenges(currentLocation);
  }

  void detectChallengeZone(LocationData location) {
    doableChallenges.value = challengeList.where((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
      return distance <= challenge.startRadius!;
    }).toList();

    achievableChallenges.value = challengeList.where((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.endLat, challenge.endLon);
      return distance <= challenge.endRadius!;
    }).toList();
  }

  void autoFinishChallenge(CurrentUserStateModel userState) async {
    if (achievableChallenges.isNotEmpty && userState.exercise != null) {
      bool hasArrived = achievableChallenges.any((challenge) {
        return challenge.id == userState.exercise!.challengeId;
      });

      if (hasArrived && userState.exercise!.badgeIssueId == null) {
        InventoryBadgeModel badge = await BadgeService.fetchUserIssuanceBadge(userState.exercise!.id!);
        userState.exercise!.badgeIssueId = badge.id;
      }
    }
  }
}
