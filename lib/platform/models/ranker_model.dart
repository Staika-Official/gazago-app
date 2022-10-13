import 'package:json_annotation/json_annotation.dart';

part 'ranker_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RankerModel {
  int? id;
  int? userId;
  int? ranking;
  String profileImageUrl;
  String nickname;
  double rewardGo;
  double rewardTik;
  String aggregatedDate;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

  RankerModel({
    this.id,
    this.userId,
    this.ranking,
    required this.profileImageUrl,
    required this.nickname,
    required this.rewardGo,
    required this.rewardTik,
    required this.aggregatedDate,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory RankerModel.fromJson(Map<String, dynamic> json) => _$RankerModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankerModelToJson(this);
}
