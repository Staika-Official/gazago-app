import 'package:json_annotation/json_annotation.dart';

part 'company_crew_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyCrewListModel {
  int crewId;
  double distance;
  String crewName;
  String crewIconImageUrl;
  bool? listFixed;

  CompanyCrewListModel({
    required this.crewId,
    required this.distance,
    required this.crewName,
    required this.crewIconImageUrl,
     this.listFixed,
  });

  factory CompanyCrewListModel.fromJson(Map<String, dynamic> json) => _$CompanyCrewListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyCrewListModelToJson(this);
}
