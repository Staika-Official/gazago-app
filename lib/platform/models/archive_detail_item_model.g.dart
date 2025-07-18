// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_detail_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveDetailItemModel _$ArchiveDetailItemModelFromJson(
        Map<String, dynamic> json) =>
    ArchiveDetailItemModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      type: json['type'] as String?,
      steps: (json['steps'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      time: (json['time'] as num?)?.toInt(),
      startedDate: json['startedDate'] as String?,
      endedDate: json['endedDate'] as String?,
      rewardGo: (json['rewardGo'] as num?)?.toDouble(),
      rewardDistance: (json['rewardDistance'] as num?)?.toDouble(),
      state: json['state'] as String?,
      badgeIssueId: (json['badgeIssueId'] as num?)?.toInt(),
      challengeId: (json['challengeId'] as num?)?.toInt(),
      challengeCourseId: (json['challengeCourseId'] as num?)?.toInt(),
      challengeActivationType: json['challengeActivationType'] as String?,
      badgeName: json['badgeName'] as String?,
      badgeImageUrl: json['badgeImageUrl'] as String?,
      spendDurability: (json['spendDurability'] as num?)?.toDouble(),
      spendStamina: (json['spendStamina'] as num?)?.toDouble(),
      title: json['title'] as String?,
      firstName: json['firstName'] as String?,
      secondName: json['secondName'] as String?,
      startPointName: json['startPointName'] as String?,
      endPointName: json['endPointName'] as String?,
      description: json['description'] as String?,
      province: json['province'] as String?,
      rewardGoExerciseSum: (json['rewardGoExerciseSum'] as num?)?.toDouble(),
      rewardGoAdSum: (json['rewardGoAdSum'] as num?)?.toDouble(),
      luckApplyTotalRewardGo:
          (json['luckApplyTotalRewardGo'] as num?)?.toDouble(),
      luckOccurredCount: (json['luckOccurredCount'] as num?)?.toInt(),
      locationsStr: json['locationsStr'] as String?,
      challengeCourse: json['challengeCourse'] == null
          ? null
          : ChallengeCourseModel.fromJson(
              json['challengeCourse'] as Map<String, dynamic>),
      isTwoMonthAgo: json['isTwoMonthAgo'] as bool?,
    );

Map<String, dynamic> _$ArchiveDetailItemModelToJson(
        ArchiveDetailItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'steps': instance.steps,
      'speed': instance.speed,
      'distance': instance.distance,
      'altitude': instance.altitude,
      'time': instance.time,
      'startedDate': instance.startedDate,
      'endedDate': instance.endedDate,
      'rewardGo': instance.rewardGo,
      'rewardDistance': instance.rewardDistance,
      'state': instance.state,
      'badgeIssueId': instance.badgeIssueId,
      'challengeId': instance.challengeId,
      'challengeCourseId': instance.challengeCourseId,
      'challengeActivationType': instance.challengeActivationType,
      'badgeName': instance.badgeName,
      'badgeImageUrl': instance.badgeImageUrl,
      'spendDurability': instance.spendDurability,
      'spendStamina': instance.spendStamina,
      'title': instance.title,
      'firstName': instance.firstName,
      'secondName': instance.secondName,
      'startPointName': instance.startPointName,
      'endPointName': instance.endPointName,
      'description': instance.description,
      'province': instance.province,
      'rewardGoExerciseSum': instance.rewardGoExerciseSum,
      'rewardGoAdSum': instance.rewardGoAdSum,
      'luckApplyTotalRewardGo': instance.luckApplyTotalRewardGo,
      'luckOccurredCount': instance.luckOccurredCount,
      'locationsStr': instance.locationsStr,
      'challengeCourse': instance.challengeCourse?.toJson(),
      'isTwoMonthAgo': instance.isTwoMonthAgo,
    };
