// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStateModelAdapter extends TypeAdapter<UserStateModel> {
  @override
  final int typeId = 0;

  @override
  UserStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStateModel(
      id: fields[0] as int,
      userId: fields[1] as int,
      stamina: fields[2] as double?,
      dailyGoReward: fields[4] as double?,
      createdBy: fields[5] as String?,
      createdDate: fields[6] as String?,
      lastModifiedBy: fields[7] as String?,
      lastModifiedDate: fields[8] as String?,
      locked: fields[9] as bool?,
    )..badgeCoolDown = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, UserStateModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.stamina)
      ..writeByte(3)
      ..write(obj.badgeCoolDown)
      ..writeByte(4)
      ..write(obj.dailyGoReward)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.lastModifiedBy)
      ..writeByte(8)
      ..write(obj.lastModifiedDate)
      ..writeByte(9)
      ..write(obj.locked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStateModel _$UserStateModelFromJson(Map<String, dynamic> json) =>
    UserStateModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      stamina: (json['stamina'] as num?)?.toDouble(),
      dailyGoReward: (json['dailyGoReward'] as num?)?.toDouble(),
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
      locked: json['locked'] as bool?,
    )..badgeCoolDown = json['badgeCoolDown'] as String?;

Map<String, dynamic> _$UserStateModelToJson(UserStateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'stamina': instance.stamina,
      'badgeCoolDown': instance.badgeCoolDown,
      'dailyGoReward': instance.dailyGoReward,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'locked': instance.locked,
    };
