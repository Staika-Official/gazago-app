import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_hierarchy_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeHierarchyModel {
  String name;
  String? province;
  List<ChallengeModel> course;

  ChallengeHierarchyModel({required this.name, this.province, required this.course});

  factory ChallengeHierarchyModel.fromJson(Map<String, dynamic> json) => _$ChallengeHierarchyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeHierarchyModelToJson(this);
}
