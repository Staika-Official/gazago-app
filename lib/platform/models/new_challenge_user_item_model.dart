import 'package:json_annotation/json_annotation.dart';

part 'new_challenge_user_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewChallengeUserItemModel {
  int id;
  bool equipped;

  NewChallengeUserItemModel({
    required this.id,
    required this.equipped,
  });

  factory NewChallengeUserItemModel.fromJson(Map<String, dynamic> json) => _$NewChallengeUserItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewChallengeUserItemModelToJson(this);
}
