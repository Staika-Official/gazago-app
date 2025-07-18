import 'package:json_annotation/json_annotation.dart';

part 'promotion_ad_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PromotionAdModel {
  int? id;
  String? title;
  String? imageUrl;
  String? subImageUrl;
  String? label;
  String? openType;
  String? linkUrl;
  int? referenceId;
  int? listOrder;

  PromotionAdModel({
    this.id,
    this.title,
    this.imageUrl,
    this.subImageUrl,
    this.label,
    this.openType,
    this.linkUrl,
    this.referenceId,
    this.listOrder,
  });

  factory PromotionAdModel.fromJson(Map<String, dynamic> json) => _$PromotionAdModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionAdModelToJson(this);
}
