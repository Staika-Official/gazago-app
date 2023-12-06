import 'package:json_annotation/json_annotation.dart';

part 'promotion_ad_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PromotionAdModel {
  int? id;
  String? title;
  String? imageUrl;
  String? label;
  String? openType;
  String? linkUrl;
  int? referenceId;

  PromotionAdModel({
    this.id,
    this.title,
    this.imageUrl,
    this.label,
    this.openType,
    this.linkUrl,
    this.referenceId,
  });

  factory PromotionAdModel.fromJson(Map<String, dynamic> json) => _$PromotionAdModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionAdModelToJson(this);
}
