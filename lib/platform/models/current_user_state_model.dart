import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user_state_model.g.dart';

@JsonSerializable()
class CurrentUserStateModel {
  UserStateModel? state;
  UserExerciseModel? exercise;

  CurrentUserStateModel({
    this.state,
    this.exercise,
  });

  factory CurrentUserStateModel.fromJson(Map<String, dynamic> json) => _$CurrentUserStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserStateModelToJson(this);
}
