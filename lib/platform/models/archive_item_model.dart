import 'package:gaza_go/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'archive_item_model.g.dart';

@JsonSerializable()
class ArchiveItemModel {
  int id;
  ActivityType activityType;
  String startTime;
  String endTime;
  String startLocation;
  String startLocationFull;
  String acquiredBadge;
  String activityDuration;
  double activityDistance;
  int stepCount;
  double avgSpeed;
  double highestClimbed;
  double acquiredGo;
  double staminaUsed;
  double durabilityConsumed;

  ArchiveItemModel({
    required this.id,
    required this.activityType,
    required this.startTime,
    required this.endTime,
    required this.startLocation,
    required this.startLocationFull,
    required this.acquiredBadge,
    required this.activityDuration,
    required this.activityDistance,
    required this.stepCount,
    required this.avgSpeed,
    required this.highestClimbed,
    required this.acquiredGo,
    required this.staminaUsed,
    required this.durabilityConsumed,
  });

  factory ArchiveItemModel.fromJson(Map<String, dynamic> json) => _$ArchiveItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveItemModelToJson(this);
}
