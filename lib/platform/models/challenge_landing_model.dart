import 'package:json_annotation/json_annotation.dart';

part 'challenge_landing_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeLandingModel {
  int id;
  String? title;
  String? imageUrl;
  String? label;
  String? openType;
  String? linkUrl;

  ChallengeLandingModel({
    required this.id,
    this.title,
    this.imageUrl,
    this.label,
    this.openType,
    this.linkUrl,
  });

  factory ChallengeLandingModel.fromJson(Map<String, dynamic> json) => _$ChallengeLandingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeLandingModelToJson(this);
}
