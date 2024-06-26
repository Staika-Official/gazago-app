import 'package:gaza_go/platform/models/gathering_reward_badge_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_badges_summaries_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserBadgesSummariesModel {
  int id;
  String state;
  int badgeComposeConfigId;
  String imageUrl;

  UserBadgesSummariesModel({
    required this.id,
    required this.state,
    required this.badgeComposeConfigId,
    required this.imageUrl,

  });

  factory UserBadgesSummariesModel.fromJson(Map<String, dynamic> json) => _$UserBadgesSummariesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserBadgesSummariesModelToJson(this);
}
