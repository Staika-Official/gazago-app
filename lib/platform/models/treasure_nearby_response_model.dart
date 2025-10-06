import 'package:json_annotation/json_annotation.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';

part 'treasure_nearby_response_model.g.dart';

@JsonSerializable()
class TreasureNearbyResponseModel {
  final bool success;
  final String? message;
  final List<TreasureModel>? nearbyTreasures;
  final int? totalCount;

  TreasureNearbyResponseModel({
    required this.success,
    this.message,
    this.nearbyTreasures,
    this.totalCount,
  });

  factory TreasureNearbyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TreasureNearbyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreasureNearbyResponseModelToJson(this);
}
