import 'package:gaza_go/platform/models/crew_member_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crew_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewModel {
  int? blockQuantity;
  String? crewFounderNickName;
  int? crewFounderId;
  List<CrewMemberModel>? crewMemberList;
  String? iconImageUrl;
  int? id;
  String? name;
  String? crewRecruitStatus;
  String? crewRelayStatus;

  CrewModel({
    this.crewFounderNickName,
    this.crewFounderId,
    this.iconImageUrl,
    this.crewMemberList,
    this.blockQuantity,
    this.id,
    this.name,
    this.crewRecruitStatus,
    this.crewRelayStatus,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) => _$CrewModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewModelToJson(this);
}
