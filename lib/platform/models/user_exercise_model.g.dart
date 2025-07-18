// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exercise_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserExerciseModelAdapter extends TypeAdapter<UserExerciseModel> {
  @override
  final int typeId = 1;

  @override
  UserExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserExerciseModel(
      id: fields[0] as int?,
      userId: fields[1] as int?,
      steps: fields[2] as int?,
      speed: fields[3] as double?,
      distance: fields[4] as double?,
      altitude: fields[5] as double?,
      time: fields[6] as int?,
      startPoint: fields[7] as String?,
      rewardGo: fields[8] as num?,
      rewardDistance: fields[9] as double?,
      spendStamina: fields[10] as double?,
      spendDurability: fields[11] as double?,
      startedDate: fields[12] as String?,
      endedDate: fields[13] as String?,
      locations: fields[14] as String?,
      badgeIssueId: fields[15] as int?,
      state: fields[16] as String?,
      deleted: fields[17] as bool?,
      createdBy: fields[18] as String?,
      createdDate: fields[19] as String?,
      lastModifiedBy: fields[20] as String?,
      lastModifiedDate: fields[21] as String?,
      type: fields[22] as String?,
      userProfileImageUrl: fields[23] as String?,
      userNickname: fields[24] as String?,
      challengeId: fields[25] as int?,
      locationUpdateTime: fields[26] as DateTime?,
      recordState: fields[27] as String?,
      adId: fields[28] as String?,
      lastLatitude: fields[29] as double?,
      lastLongitude: fields[30] as double?,
      latestLocations: (fields[31] as List?)
          ?.map((dynamic e) => (e as List).cast<dynamic>())
          .toList(),
      luckOccurredCount: fields[32] as int?,
      luckApplyTotalRewardGo: fields[33] as double?,
      luckOccurred: fields[34] as bool?,
      luckApplyRewardGo: fields[35] as double?,
      badgeImageUrl: fields[36] as String?,
      badgeIssued: fields[37] as bool?,
      sequence: fields[38] as String?,
      challengeCourseId: fields[39] as int?,
      crewBuffLevel: fields[40] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserExerciseModel obj) {
    writer
      ..writeByte(41)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.speed)
      ..writeByte(4)
      ..write(obj.distance)
      ..writeByte(5)
      ..write(obj.altitude)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.startPoint)
      ..writeByte(8)
      ..write(obj.rewardGo)
      ..writeByte(9)
      ..write(obj.rewardDistance)
      ..writeByte(10)
      ..write(obj.spendStamina)
      ..writeByte(11)
      ..write(obj.spendDurability)
      ..writeByte(12)
      ..write(obj.startedDate)
      ..writeByte(13)
      ..write(obj.endedDate)
      ..writeByte(14)
      ..write(obj.locations)
      ..writeByte(15)
      ..write(obj.badgeIssueId)
      ..writeByte(16)
      ..write(obj.state)
      ..writeByte(17)
      ..write(obj.deleted)
      ..writeByte(18)
      ..write(obj.createdBy)
      ..writeByte(19)
      ..write(obj.createdDate)
      ..writeByte(20)
      ..write(obj.lastModifiedBy)
      ..writeByte(21)
      ..write(obj.lastModifiedDate)
      ..writeByte(22)
      ..write(obj.type)
      ..writeByte(23)
      ..write(obj.userProfileImageUrl)
      ..writeByte(24)
      ..write(obj.userNickname)
      ..writeByte(25)
      ..write(obj.challengeId)
      ..writeByte(26)
      ..write(obj.locationUpdateTime)
      ..writeByte(27)
      ..write(obj.recordState)
      ..writeByte(28)
      ..write(obj.adId)
      ..writeByte(29)
      ..write(obj.lastLatitude)
      ..writeByte(30)
      ..write(obj.lastLongitude)
      ..writeByte(31)
      ..write(obj.latestLocations)
      ..writeByte(32)
      ..write(obj.luckOccurredCount)
      ..writeByte(33)
      ..write(obj.luckApplyTotalRewardGo)
      ..writeByte(34)
      ..write(obj.luckOccurred)
      ..writeByte(35)
      ..write(obj.luckApplyRewardGo)
      ..writeByte(36)
      ..write(obj.badgeImageUrl)
      ..writeByte(37)
      ..write(obj.badgeIssued)
      ..writeByte(38)
      ..write(obj.sequence)
      ..writeByte(39)
      ..write(obj.challengeCourseId)
      ..writeByte(40)
      ..write(obj.crewBuffLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExerciseModel _$UserExerciseModelFromJson(Map<String, dynamic> json) =>
    UserExerciseModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      steps: (json['steps'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      time: (json['time'] as num?)?.toInt(),
      startPoint: json['startPoint'] as String?,
      rewardGo: json['rewardGo'] as num?,
      rewardDistance: (json['rewardDistance'] as num?)?.toDouble(),
      spendStamina: (json['spendStamina'] as num?)?.toDouble(),
      spendDurability: (json['spendDurability'] as num?)?.toDouble(),
      startedDate: json['startedDate'] as String?,
      endedDate: json['endedDate'] as String?,
      locations: json['locations'] as String?,
      badgeIssueId: (json['badgeIssueId'] as num?)?.toInt(),
      state: json['state'] as String?,
      deleted: json['deleted'] as bool?,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
      type: json['type'] as String?,
      userProfileImageUrl: json['userProfileImageUrl'] as String?,
      userNickname: json['userNickname'] as String?,
      challengeId: (json['challengeId'] as num?)?.toInt(),
      locationUpdateTime: json['locationUpdateTime'] == null
          ? null
          : DateTime.parse(json['locationUpdateTime'] as String),
      recordState: json['recordState'] as String?,
      adId: json['adId'] as String?,
      lastLatitude: (json['lastLatitude'] as num?)?.toDouble(),
      lastLongitude: (json['lastLongitude'] as num?)?.toDouble(),
      latestLocations: (json['latestLocations'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      luckOccurredCount: (json['luckOccurredCount'] as num?)?.toInt(),
      luckApplyTotalRewardGo:
          (json['luckApplyTotalRewardGo'] as num?)?.toDouble(),
      luckOccurred: json['luckOccurred'] as bool?,
      luckApplyRewardGo: (json['luckApplyRewardGo'] as num?)?.toDouble(),
      badgeImageUrl: json['badgeImageUrl'] as String?,
      badgeIssued: json['badgeIssued'] as bool?,
      sequence: json['sequence'] as String?,
      challengeCourseId: (json['challengeCourseId'] as num?)?.toInt(),
      crewBuffLevel: json['crewBuffLevel'] as String?,
    );

Map<String, dynamic> _$UserExerciseModelToJson(UserExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'steps': instance.steps,
      'speed': instance.speed,
      'distance': instance.distance,
      'altitude': instance.altitude,
      'time': instance.time,
      'startPoint': instance.startPoint,
      'rewardGo': instance.rewardGo,
      'rewardDistance': instance.rewardDistance,
      'spendStamina': instance.spendStamina,
      'spendDurability': instance.spendDurability,
      'startedDate': instance.startedDate,
      'endedDate': instance.endedDate,
      'locations': instance.locations,
      'badgeIssueId': instance.badgeIssueId,
      'state': instance.state,
      'deleted': instance.deleted,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'type': instance.type,
      'userProfileImageUrl': instance.userProfileImageUrl,
      'userNickname': instance.userNickname,
      'challengeId': instance.challengeId,
      'locationUpdateTime': instance.locationUpdateTime?.toIso8601String(),
      'recordState': instance.recordState,
      'adId': instance.adId,
      'lastLatitude': instance.lastLatitude,
      'lastLongitude': instance.lastLongitude,
      'latestLocations': instance.latestLocations,
      'luckOccurredCount': instance.luckOccurredCount,
      'luckApplyTotalRewardGo': instance.luckApplyTotalRewardGo,
      'luckOccurred': instance.luckOccurred,
      'luckApplyRewardGo': instance.luckApplyRewardGo,
      'badgeImageUrl': instance.badgeImageUrl,
      'badgeIssued': instance.badgeIssued,
      'sequence': instance.sequence,
      'challengeCourseId': instance.challengeCourseId,
      'crewBuffLevel': instance.crewBuffLevel,
    };
