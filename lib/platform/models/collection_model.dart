import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionModel {
  int id;
  String name;
  String type;
  String description;
  String gatheringDifficultyType;
  String imageUrl;
  String grayscaleImageUrl;
  String? fromDateTime;
  String? toDateTime;
  List<GatheringConditionModel> gatheringConditions;
  GatheringConditionModel gatheringReward;
  bool alreadyIssued;

  CollectionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.gatheringDifficultyType,
    required this.imageUrl,
    required this.grayscaleImageUrl,
    this.fromDateTime,
    this.toDateTime,
    required this.gatheringConditions,
    required this.gatheringReward,
    required this.alreadyIssued,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) => _$CollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);
}
