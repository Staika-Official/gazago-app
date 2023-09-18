import 'package:json_annotation/json_annotation.dart';

part 'ranker_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RankerModel {
  int? id;
  int? userId;
  int? rank;
  String? profileImageUrl;
  String nickname;
  double rewardGo;
  double rewardTik;
  double? additionTik;
  double? additionStik;
  String aggregatedDate;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  String userKeyword;

  RankerModel({
    this.id,
    this.userId,
    this.rank,
    required this.profileImageUrl,
    required this.nickname,
    required this.rewardGo,
    required this.rewardTik,
    required this.aggregatedDate,
    this.additionTik,
    this.additionStik,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    required this.userKeyword,
  });

  factory RankerModel.fromJson(Map<String, dynamic> json) => _$RankerModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankerModelToJson(this);
}
