import 'package:json_annotation/json_annotation.dart';

part 'crew_member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CrewMemberModel {
  int? blockQuantity;
  String? imageUrl;
  int? inviteCount;
  String? nickname;

  CrewMemberModel({
    this.blockQuantity,
    this.imageUrl,
    this.inviteCount,
    this.nickname,
  });

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) => _$CrewMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrewMemberModelToJson(this);
}
