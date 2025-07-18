import 'package:gaza_go/platform/models/challenge_landing_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'join_challenge_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JoinChallengeResponseModel {
  int challengeId;
  ChallengeLandingModel? challengeLanding;

  JoinChallengeResponseModel({
    required this.challengeId,
    this.challengeLanding,

  });

  factory JoinChallengeResponseModel.fromJson(Map<String, dynamic> json) => _$JoinChallengeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinChallengeResponseModelToJson(this);
}
