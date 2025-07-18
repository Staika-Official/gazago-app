import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_shoes_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user_state_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(explicitToJson: true)
class CurrentUserStateModel {
  @HiveField(0)
  UserStateModel? state;
  @HiveField(1)
  UserExerciseModel? exercise;
  @HiveField(2)
  UserShoesModel? shoes;

  CurrentUserStateModel({
    this.state,
    this.exercise,
    this.shoes,
  });

  factory CurrentUserStateModel.fromJson(Map<String, dynamic> json) => _$CurrentUserStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserStateModelToJson(this);
}
