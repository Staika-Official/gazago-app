import 'package:json_annotation/json_annotation.dart';

part 'challenge_join_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeJoinModel {

  String challengeActivationType;
  String? code;
  int? entryFee;
  int? itemId;


  ChallengeJoinModel({
    required this.challengeActivationType,
    this.code,
    this.entryFee,
    this.itemId,
  });

  factory ChallengeJoinModel.fromJson(Map<String, dynamic> json) => _$ChallengeJoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeJoinModelToJson(this);
}
