import 'package:gaza_go/platform/models/benefit_item_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_benefit_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyBenefitListModel {
  UserExerciseModel userExercise;
  List<BenefitItemModel> benefits;

  DailyBenefitListModel({
    required this.userExercise,
    required this.benefits,
  });

  factory DailyBenefitListModel.fromJson(Map<String, dynamic> json) => _$DailyBenefitListModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyBenefitListModelToJson(this);
}
