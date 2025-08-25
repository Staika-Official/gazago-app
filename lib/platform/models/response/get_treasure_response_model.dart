import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_treasure_response_model.g.dart';

@JsonSerializable()
class GetTreasureResponseModel {
  final List<TreasureModel> treasures;
  final int cooldownDuration;
  final int minPickupDistance;

  GetTreasureResponseModel({
    required this.treasures,
    required this.cooldownDuration,
    required this.minPickupDistance,
  });

  factory GetTreasureResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetTreasureResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetTreasureResponseModelToJson(this);
}
