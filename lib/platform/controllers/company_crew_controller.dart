import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class CompanyCrewController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  RxString challengeId = RxString('');
  RxInt myCrewJoinedCount = RxInt(0);
  RxInt myCrewTotalCount = RxInt(0);
  int myCrewId = 0;
  String? userId = '';
  RxList myCrewList = RxList.empty();
  RxMap myCrewInfo = RxMap({});
  RxMap myChallengeInfo = RxMap({});
  RxString totalDistance = RxString('');
  RxString ranking = RxString('');
  RxList crewList = RxList.empty();
  RxList crewManagerList = RxList.empty();
  RxList crewRankingList = RxList.empty();
  RxList crewMemberList = RxList.empty();
  late StreamSubscription subscription;

  @override
  void onInit() async {
    userId = HiveStore.loadString(key: HiveKey.userId.name);
    if (await Get.arguments != null) {
      challengeId.value = await Get.arguments['id'];
    } else {
      challengeId.value = Get.parameters['id']!;
    }
    streamGetCompanyChallengeUserList();

    super.onInit();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  void streamGetCompanyChallengeUserList() async {
    DatabaseReference expiredItemsRef = FirebaseDatabase.instance.ref('crewChallengeLeaderboard/${challengeId.value}');

    subscription = expiredItemsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        myCrewList = RxList.empty();
        myCrewInfo.clear();
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          List<List<Map<String, dynamic>>> groupedData = groupDataByCrewId(data);
          List<Map<String, dynamic>> modifiedGroupedData = [];

          for (var crewData in groupedData) {
            double totalRewardDistance = 0;
            int objectCount = crewData.length;
            for (var userData in crewData) {
              totalRewardDistance += userData['rewardDistance'];
              // if (userData['userId'] == int.parse(userId!)) {

              if (userData['userId'] == int.parse(userId!)) {
                myCrewId = userData['crewId'];
              }
            }
            double distance = objectCount > 0 ? totalRewardDistance / objectCount : 0.0;
            String crewName = crewData.first['crewName'] as String;
            String crewIconImageUrl = crewData.first['crewIconImageUrl'] as String;
            bool listFixed = crewData.first['listFixed'] as bool;
            int crewId = crewData.first['crewId'] as int;
            int maxMemberCount = crewData.first['maxMemberCount'] as int;
            modifiedGroupedData.add({
              'crewId': crewId,
              'crewName': crewName,
              'crewIconImageUrl': crewIconImageUrl,
              'distance': distance,
              'listFixed': listFixed,
              'maxMemberCount': maxMemberCount,
            });

            if (myCrewId != 0 && crewData.any((userData) => userData['crewId'] == myCrewId)) {
              myCrewList.addAll(crewData.where((userData) => userData['crewId'] == myCrewId));
            }
          }
          modifiedGroupedData.sort((a, b) {
            // Sort by distance descending
            if (a['distance'] != b['distance']) {
              return b['distance'].compareTo(a['distance']);
            }
            // If distance is the same, sort by crewName in descending alphabetical order
            if (a['crewName'] != null && b['crewName'] != null) {
              return a['crewName'].compareTo(b['crewName']);
            }
            return 0;
          });
          for (int i = 0; i < modifiedGroupedData.length; i++) {
            modifiedGroupedData[i]['rank'] = i + 1; // 순위 추가
          }

          myCrewList.sort((a, b) {
            // userId가 70432인 항목이 있는지 확인

            bool aIsCurrentUser = a['userId'] == int.parse(userId!);
            bool bIsCurrentUser = b['userId'] == int.parse(userId!);

            // userId가 70432인 항목이 있는 경우 해당 항목을 맨 앞으로 오도록 정렬
            if (aIsCurrentUser && !bIsCurrentUser) {
              return -1; // a를 b보다 앞으로 배치
            } else if (!aIsCurrentUser && bIsCurrentUser) {
              return 1; // b를 a보다 앞으로 배치
            } else {
              // 그 외의 경우 거리가 높은 순서대로 정렬
              return b['rewardDistance'].compareTo(a['rewardDistance']);
            }
          });

          crewManagerList.value = modifiedGroupedData.where((crew) => crew['listFixed'] == true).toList();

          myCrewInfo = RxMap(modifiedGroupedData.firstWhere((crew) => crew['crewId'] == myCrewId, orElse: () => {}));
          crewRankingList.value = modifiedGroupedData;
          myCrewList.refresh();
          myCrewInfo.refresh();
        }
      }
    });
  }

  void setCrewRankingList() {}

  List<List<Map<String, dynamic>>> groupDataByCrewId(Map<dynamic, dynamic> data) {
    Map<int, List<Map<String, dynamic>>> groupedData = {};

    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        // 유효한 맵인지 확인
        int? crewId = value['crewId'] as int?;
        if (crewId != null) {
          if (!groupedData.containsKey(crewId)) {
            groupedData[crewId] = [];
          }
          groupedData[crewId]!.add(value.cast<String, dynamic>()); // Map<dynamic, dynamic>을 Map<String, dynamic>으로 변환
        }
      }
    });

    return groupedData.values.toList();
  }
}
