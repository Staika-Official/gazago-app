import 'package:json_annotation/json_annotation.dart';

part 'challenge_badge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeBadgeModel {
  int? id;
  String? name;
  String? imageUrl;
  String? description;
  int? limitedCount;

  ChallengeBadgeModel({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.limitedCount,
  });

  factory ChallengeBadgeModel.fromJson(Map<String, dynamic> json) => _$ChallengeBadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeBadgeModelToJson(this);
}
