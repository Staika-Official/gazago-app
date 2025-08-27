import 'package:json_annotation/json_annotation.dart';

part 'treasure_model.g.dart';

@JsonSerializable()
class TreasureModel {
  final int id;
  final double latitude;
  final double longitude;
  final dynamic location;
  final String name;
  final String nameEn;
  final int amount;
  final String treasureSymbol;
  final dynamic claimedBy;
  final DateTime? claimedTime;
  final String? iconUrl;
  final int userExerciseId;
  final String distributionMode;
  final String status;
  final TreasureType type;

  TreasureModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.location,
    required this.name,
    required this.nameEn,
    required this.amount,
    required this.treasureSymbol,
    this.claimedBy,
    this.claimedTime,
    this.iconUrl,
    required this.userExerciseId,
    required this.distributionMode,
    required this.status,
    required this.type,
  });

  factory TreasureModel.fromJson(Map<String, dynamic> json) =>
      _$TreasureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreasureModelToJson(this);

  String get iconPathLocal => type == TreasureType.normal
      ? 'assets/images/activity/ico_treasure_normal.svg'
      : 'assets/images/activity/ico_treasure_event.svg';
}

enum TreasureType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('EVENT')
  event,
}
