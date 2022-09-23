import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_current_states_model.g.dart';

@JsonSerializable()
class UserCurrentStatesModel {
  UserStateModel state;
  UserExerciseModel exercise;

  UserCurrentStatesModel({
    required this.state,
    required this.exercise,
  });

  factory UserCurrentStatesModel.fromJson(Map<String, dynamic> json) => _$UserCurrentStatesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserCurrentStatesModelToJson(this);
}
