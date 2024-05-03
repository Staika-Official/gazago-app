import 'package:json_annotation/json_annotation.dart';

part 'company_challenge_available_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyChallengeAvailableModel {
  int id;
  String employeeId;
  int alliancePromotionId;
  int? userId;
  String name;
  String departName;


  CompanyChallengeAvailableModel({
    required this.id,
    required this.alliancePromotionId,
    this.userId,
    required this.employeeId,
    required this.name,
    required this.departName,

  });

  factory CompanyChallengeAvailableModel.fromJson(Map<String, dynamic> json) => _$CompanyChallengeAvailableModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyChallengeAvailableModelToJson(this);
}
