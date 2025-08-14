import 'package:json_annotation/json_annotation.dart';

part 'referral_history_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferralHistoryModel {
  final int id;
  final String name;
  final int points;
  final bool isClaimed;

  const ReferralHistoryModel({
    required this.id,
    required this.name,
    required this.points,
    required this.isClaimed,
  });

  factory ReferralHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralHistoryModelToJson(this);
}
