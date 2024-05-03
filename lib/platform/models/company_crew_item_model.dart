import 'package:json_annotation/json_annotation.dart';

part 'company_crew_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyCrewItemModel {
  int crewId;
  int userId;
  int rewardDistance;
  String crewName;
  String nickname;
  String crewIconImageUrl;
  String profileImageUrl;
  bool listFixed;

  CompanyCrewItemModel({
    required this.crewId,
    required this.userId,
    required this.rewardDistance,
    required this.crewName,
    required this.nickname,
    required this.crewIconImageUrl,
    required this.profileImageUrl,
    required this.listFixed,
  });

  factory CompanyCrewItemModel.fromJson(Map<String, dynamic> json) => _$CompanyCrewItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyCrewItemModelToJson(this);
}
