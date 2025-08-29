import 'package:json_annotation/json_annotation.dart';

part 'treasure_model.g.dart';

@JsonSerializable()
class TreasureModel {
  final int? id;
  final double? latitude;
  final double? longitude;
  final dynamic location;
  final String? name;
  final String? nameEn;
  final int? amount;
  final String? treasureSymbol;
  final dynamic claimedBy;
  final DateTime? claimedTime;
  final String? iconUrl;
  final int? userExerciseId;
  final TreasureDistributionMode distributionMode;
  final TreasureStatus status;
  final TreasureType type;

  TreasureModel({
    this.id,
    this.latitude,
    this.longitude,
    this.location,
    this.name,
    this.nameEn,
    this.amount,
    this.treasureSymbol,
    this.claimedBy,
    this.claimedTime,
    this.iconUrl,
    this.userExerciseId,
    required this.distributionMode,
    required this.status,
    required this.type,
  });

  factory TreasureModel.fromJson(Map<String, dynamic> json) =>
      _$TreasureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreasureModelToJson(this);

  String get iconPathLocal => type == TreasureType.normal
      ? 'assets/images/activity/ico_treasure_normal.svg'
      : type == TreasureType.event
          ? 'assets/images/activity/ico_treasure_event.svg'
          : 'assets/images/activity/ico_treasure_normal.svg';
}

enum TreasureDistributionMode {
  @JsonValue('RANDOM')
  random,
  @JsonValue('FIXED')
  fixed,
}

enum TreasureStatus {
  @JsonValue('CREATED')
  created,
  @JsonValue('CLAIMED')
  claimed,
}

enum TreasureType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('EVENT')
  event,
}
