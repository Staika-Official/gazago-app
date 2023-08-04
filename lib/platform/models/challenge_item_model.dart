import 'package:json_annotation/json_annotation.dart';

part 'challenge_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeItemModel {
  int? id;
  String? name;
  String? itemImageUrl;
  double? price;
  String? tradeSymbol;
  String? itemLabel;

  ChallengeItemModel({this.id, this.name, this.itemImageUrl, this.price, this.tradeSymbol, this.itemLabel});

  factory ChallengeItemModel.fromJson(Map<String, dynamic> json) => _$ChallengeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeItemModelToJson(this);
}
