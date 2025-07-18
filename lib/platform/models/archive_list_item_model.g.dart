// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveListItemModel _$ArchiveListItemModelFromJson(
        Map<String, dynamic> json) =>
    ArchiveListItemModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      type: json['type'] as String?,
      steps: (json['steps'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      maxAltitude: (json['maxAltitude'] as num?)?.toDouble(),
      time: (json['time'] as num?)?.toInt(),
      startedDate: json['startedDate'] as String?,
      endedDate: json['endedDate'] as String?,
      rewardGo: (json['rewardGo'] as num?)?.toDouble(),
      rewardDistance: (json['rewardDistance'] as num?)?.toDouble(),
      spendDurability: (json['spendDurability'] as num?)?.toDouble(),
      spendStamina: (json['spendStamina'] as num?)?.toDouble(),
      state: json['state'] as String?,
      badgeIssueId: (json['badgeIssueId'] as num?)?.toInt(),
      challengeId: (json['challengeId'] as num?)?.toInt(),
      challengeCourseId: (json['challengeCourseId'] as num?)?.toInt(),
      challengeActivationType: json['challengeActivationType'] as String?,
      badgeName: json['badgeName'] as String?,
      badgeImageUrl: json['badgeImageUrl'] as String?,
      challengeTitle: json['challengeTitle'] as String?,
      degreeRewardGo: (json['degreeRewardGo'] as num?)?.toDouble(),
      degreeSpendDurability:
          (json['degreeSpendDurability'] as num?)?.toDouble(),
      degreeSpendStamina: (json['degreeSpendStamina'] as num?)?.toDouble(),
      luckOccurredCount: (json['luckOccurredCount'] as num?)?.toInt(),
      luckApplyRewardGo: (json['luckApplyRewardGo'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ArchiveListItemModelToJson(
        ArchiveListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'steps': instance.steps,
      'speed': instance.speed,
      'distance': instance.distance,
      'altitude': instance.altitude,
      'maxAltitude': instance.maxAltitude,
      'time': instance.time,
      'startedDate': instance.startedDate,
      'endedDate': instance.endedDate,
      'rewardGo': instance.rewardGo,
      'rewardDistance': instance.rewardDistance,
      'spendDurability': instance.spendDurability,
      'spendStamina': instance.spendStamina,
      'state': instance.state,
      'badgeIssueId': instance.badgeIssueId,
      'challengeId': instance.challengeId,
      'challengeCourseId': instance.challengeCourseId,
      'challengeActivationType': instance.challengeActivationType,
      'badgeName': instance.badgeName,
      'badgeImageUrl': instance.badgeImageUrl,
      'challengeTitle': instance.challengeTitle,
      'degreeRewardGo': instance.degreeRewardGo,
      'degreeSpendDurability': instance.degreeSpendDurability,
      'degreeSpendStamina': instance.degreeSpendStamina,
      'luckOccurredCount': instance.luckOccurredCount,
      'luckApplyRewardGo': instance.luckApplyRewardGo,
    };
