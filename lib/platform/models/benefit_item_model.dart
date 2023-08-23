import 'package:json_annotation/json_annotation.dart';

part 'benefit_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BenefitItemModel {
  int id;
  String benefitType;
  double distance;
  double? amount;
  String? imageUrl;
  bool adDisplayed;
  String label;
  String labelReceived;
  bool received;
  String? benefitDate;

  BenefitItemModel({
    required this.id,
    required this.benefitType,
    required this.distance,
    this.amount,
    this.imageUrl,
    required this.adDisplayed,
    required this.label,
    required this.labelReceived,
    required this.received,
    this.benefitDate,
  });

  factory BenefitItemModel.fromJson(Map<String, dynamic> json) => _$BenefitItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BenefitItemModelToJson(this);
}
