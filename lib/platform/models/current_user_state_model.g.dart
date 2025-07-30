// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserStateModelAdapter extends TypeAdapter<CurrentUserStateModel> {
  @override
  final int typeId = 3;

  @override
  CurrentUserStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUserStateModel(
      state: fields[0] as UserStateModel?,
      exercise: fields[1] as UserExerciseModel?,
      shoes: fields[2] as UserShoesModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUserStateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.state)
      ..writeByte(1)
      ..write(obj.exercise)
      ..writeByte(2)
      ..write(obj.shoes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserStateModel _$CurrentUserStateModelFromJson(
        Map<String, dynamic> json) =>
    CurrentUserStateModel(
      state: json['state'] == null
          ? null
          : UserStateModel.fromJson(json['state'] as Map<String, dynamic>),
      exercise: json['exercise'] == null
          ? null
          : UserExerciseModel.fromJson(
              json['exercise'] as Map<String, dynamic>),
      shoes: json['shoes'] == null
          ? null
          : UserShoesModel.fromJson(json['shoes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentUserStateModelToJson(
        CurrentUserStateModel instance) =>
    <String, dynamic>{
      'state': instance.state?.toJson(),
      'exercise': instance.exercise?.toJson(),
      'shoes': instance.shoes?.toJson(),
    };
