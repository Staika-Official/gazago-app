import 'package:json_annotation/json_annotation.dart';

part 'crew_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewModel {
  String? name;
  String? crewFounderNickName;
  String? iconImageUrl;
  int? user;
  bool? isLocked;
  int? blockQuantity;
  int? invitationCount;
  int? rank;

  CrewModel({
    this.name,
    this.crewFounderNickName,
    this.iconImageUrl,
    this.user,
    this.isLocked,
    this.blockQuantity,
    this.invitationCount,
    this.rank,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) => _$CrewModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewModelToJson(this);
}
