import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ChallengeMixin {
  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<ChallengeModel> doableChallenges = RxList.empty();
  final RxList<ChallengeModel> achievableChallenges = RxList.empty();

  void getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  void getNearByChallengeList(LocationData currentLocation) async {
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

  void autoFinishChallenge(CurrentUserStateModel userState) {
    if (achievableChallenges.isNotEmpty && userState.exercise != null) {
      bool hasArrived = achievableChallenges.any((challenge) {
        return challenge.id == userState.exercise!.challengeId;
      });

      if (hasArrived && userState.exercise!.badgeIssueId == null) {
        print('request badge issuance');
      }
    }
  }
}
