import 'package:gaza_go/platform/models/challenge_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeDetailModel {
  ChallengeInfoModel? challenge;

  ChallengeDetailModel({
    this.challenge,
  });

  factory ChallengeDetailModel.fromJson(Map<String, dynamic> json) => _$ChallengeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeDetailModelToJson(this);
}
