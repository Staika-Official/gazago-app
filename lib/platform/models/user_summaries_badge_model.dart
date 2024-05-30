import 'package:json_annotation/json_annotation.dart';

part 'user_summaries_badge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSummariesBadgeModel {
  int id;
  String state;
  int badgeComposeConfigId;


  UserSummariesBadgeModel({
    required this.id,
    required this.state,
    required this.badgeComposeConfigId,
  });

  factory UserSummariesBadgeModel.fromJson(Map<String, dynamic> json) => _$UserSummariesBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummariesBadgeModelToJson(this);
}
