import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ChallengeMixin {
  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<ChallengeModel> activeChallenge = RxList.empty();
  final RxBool isInsideChallengeStart = RxBool(false);
  final RxBool isInsideChallengeFinish = RxBool(false);

  void getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  void getNearByChallengeList(LocationData currentLocation) async {
    challengeList.value = await ActivityService.getNearByChallenges(currentLocation);
  }

  void detectChallengeZone(LocationData location) {
    isInsideChallengeStart.value = challengeList.any((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
      return distance <= challenge.startRadius!;
    });

    isInsideChallengeFinish.value = challengeList.any((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.endLat, challenge.endLon);
      return distance <= challenge.endRadius!;
    });
  }
}
