import 'package:json_annotation/json_annotation.dart';

part 'referral_config_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferralConfigModel {
  final int id;
  final bool isActive;
  final String rewardReferralSymbol;
  final int amount;
  final int maximumNumberOfReferees;

  const ReferralConfigModel({
    required this.id,
    required this.isActive,
    required this.rewardReferralSymbol,
    required this.amount,
    required this.maximumNumberOfReferees,
  });

  factory ReferralConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralConfigModelToJson(this);
}
