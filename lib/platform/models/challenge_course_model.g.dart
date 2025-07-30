// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeCourseModel _$ChallengeCourseModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeCourseModel(
      id: (json['id'] as num?)?.toInt(),
      challengeId: (json['challengeId'] as num?)?.toInt(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      firstName: json['firstName'] as String?,
      secondName: json['secondName'] as String?,
      startPointName: json['startPointName'] as String?,
      startLat: (json['startLat'] as num?)?.toDouble(),
      startLon: (json['startLon'] as num?)?.toDouble(),
      startRadius: (json['startRadius'] as num?)?.toDouble(),
      endPointName: json['endPointName'] as String?,
      endLat: (json['endLat'] as num?)?.toDouble(),
      endLon: (json['endLon'] as num?)?.toDouble(),
      endRadius: (json['endRadius'] as num?)?.toDouble(),
      difficulty: json['difficulty'] as String?,
      difficultyRate: (json['difficultyRate'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      travelTime: (json['travelTime'] as num?)?.toDouble(),
      province: json['province'] as String?,
      rewardImageUrl: json['rewardImageUrl'] as String?,
      activated: json['activated'] as bool?,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
    )..checkpoints = (json['checkpoints'] as List<dynamic>?)
        ?.map((e) => CheckpointModel.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ChallengeCourseModelToJson(
        ChallengeCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeId': instance.challengeId,
      'type': instance.type,
      'title': instance.title,
      'firstName': instance.firstName,
      'secondName': instance.secondName,
      'startPointName': instance.startPointName,
      'startLat': instance.startLat,
      'startLon': instance.startLon,
      'startRadius': instance.startRadius,
      'endPointName': instance.endPointName,
      'endLat': instance.endLat,
      'endLon': instance.endLon,
      'endRadius': instance.endRadius,
      'difficulty': instance.difficulty,
      'difficultyRate': instance.difficultyRate,
      'altitude': instance.altitude,
      'distance': instance.distance,
      'travelTime': instance.travelTime,
      'province': instance.province,
      'rewardImageUrl': instance.rewardImageUrl,
      'activated': instance.activated,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'checkpoints': instance.checkpoints?.map((e) => e.toJson()).toList(),
    };
