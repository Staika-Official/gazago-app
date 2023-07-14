import 'package:json_annotation/json_annotation.dart';

part 'new_challenge_badge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewChallengeBadgeModel {
  int? id;
  String? name;
  String? imageUrl;
  int? limitedCount;

  NewChallengeBadgeModel({
    this.id,
    this.name,
    this.imageUrl,
    this.limitedCount,
  });

  factory NewChallengeBadgeModel.fromJson(Map<String, dynamic> json) => _$NewChallengeBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewChallengeBadgeModelToJson(this);
}
