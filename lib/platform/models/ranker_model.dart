import 'package:json_annotation/json_annotation.dart';

part 'ranker_model.g.dart';

@JsonSerializable()
class RankerModel {
  String place;
  String nickname;
  String profileImageUrl;
  double goBalance;
  double tikBalance;

  RankerModel({
    required this.place,
    required this.nickname,
    required this.profileImageUrl,
    required this.goBalance,
    required this.tikBalance,
  });

  factory RankerModel.fromJson(Map<String, dynamic> json) => _$RankerModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankerModelToJson(this);
}
