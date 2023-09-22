import 'package:json_annotation/json_annotation.dart';

part 'challenge_share_template_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeShareTemplateModel {
  String imageUrl;
  String title;
  String description;
  String buttonTitle;

  ChallengeShareTemplateModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.buttonTitle,
  });

  factory ChallengeShareTemplateModel.fromJson(Map<String, dynamic> json) => _$ChallengeShareTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeShareTemplateModelToJson(this);
}
