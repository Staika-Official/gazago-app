// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_hierarchy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeHierarchyModel _$ChallengeHierarchyModelFromJson(
        Map<String, dynamic> json) =>
    ChallengeHierarchyModel(
      name: json['name'] as String,
      province: json['province'] as String?,
      course: (json['course'] as List<dynamic>)
          .map((e) => ChallengeCourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengeHierarchyModelToJson(
        ChallengeHierarchyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'province': instance.province,
      'course': instance.course.map((e) => e.toJson()).toList(),
    };
