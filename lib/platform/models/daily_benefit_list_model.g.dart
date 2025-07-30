// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_benefit_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyBenefitListModel _$DailyBenefitListModelFromJson(
        Map<String, dynamic> json) =>
    DailyBenefitListModel(
      label: json['label'] as String,
      userExercise: UserExerciseModel.fromJson(
          json['userExercise'] as Map<String, dynamic>),
      benefits: (json['benefits'] as List<dynamic>)
          .map((e) => BenefitItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyBenefitListModelToJson(
        DailyBenefitListModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'userExercise': instance.userExercise.toJson(),
      'benefits': instance.benefits.map((e) => e.toJson()).toList(),
    };
