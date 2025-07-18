import 'package:json_annotation/json_annotation.dart';

part 'new_challenge_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewChallengeItemModel {
  int id;
  String name;
  String? itemImageUrl;
  double price;
  String tradeSymbol;
  String? itemLabel;

  NewChallengeItemModel({
    required this.id,
    required this.name,
    this.itemImageUrl,
    required this.price,
    required this.tradeSymbol,
    this.itemLabel,
  });

  factory NewChallengeItemModel.fromJson(Map<String, dynamic> json) => _$NewChallengeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewChallengeItemModelToJson(this);
}
