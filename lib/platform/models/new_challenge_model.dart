import 'package:json_annotation/json_annotation.dart';

part 'new_challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewChallengeModel {
  int id;
  String? challengeState;
  String? challengeUserState;
  String challengeActivationType;
  List<String>? exerciseTypes;
  String title;
  String? subTitle;
  int? minDistance;
  int quantity;
  int? soldQuantity;
  String? publishedDate;
  String? reservedDate;
  String fromDate;
  String toDate;
  String? imageUrl;
  String? bannerImageUrl;
  String? thumbnailImageUrl;
  String? linkUrl;
  bool? infinityDisplayed;
  bool previewDisplayed;
  String? challengeRewardRuleType;
  int rewardAmount;
  String? introduce;
  String? description;

  NewChallengeModel({
    required this.id,
    this.challengeState,
    this.challengeUserState,
    required this.challengeActivationType,
    this.exerciseTypes,
    required this.title,
    this.subTitle,
    this.minDistance,
    required this.quantity,
    this.soldQuantity,
    this.publishedDate,
    this.reservedDate,
    required this.fromDate,
    required this.toDate,
    this.imageUrl,
    this.bannerImageUrl,
    this.thumbnailImageUrl,
    this.linkUrl,
    this.infinityDisplayed,
    required this.previewDisplayed,
    this.challengeRewardRuleType,
    required this.rewardAmount,
    this.introduce,
    this.description,
  });

  factory NewChallengeModel.fromJson(Map<String, dynamic> json) => _$NewChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewChallengeModelToJson(this);
}
