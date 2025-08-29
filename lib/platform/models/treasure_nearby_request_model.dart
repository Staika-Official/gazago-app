import 'package:json_annotation/json_annotation.dart';

part 'treasure_nearby_request_model.g.dart';

@JsonSerializable()
class TreasureNearbyRequestModel {
  final int userExerciseId;
  final double userLat;
  final double userLng;

  TreasureNearbyRequestModel({
    required this.userExerciseId,
    required this.userLat,
    required this.userLng,
  });

  factory TreasureNearbyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TreasureNearbyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreasureNearbyRequestModelToJson(this);
}
