import 'package:easy_localization/easy_localization.dart';
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
  final int amount;
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
    this.amount = 0,
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

  String get iconPathLocal {
    late String iconPath;
    switch (distributionMode) {
      case TreasureDistributionMode.random:
        switch (type) {
          case TreasureType.normal:
            iconPath = 'assets/images/activity/ico_treasure_normal.svg';
            break;
          case TreasureType.event:
            iconPath = 'assets/images/activity/ico_treasure_event.svg';
            break;
        }
        break;
      case TreasureDistributionMode.fixed:
        switch (type) {
          case TreasureType.normal:
            iconPath = 'assets/images/activity/ico_treasure_normal_fixed.svg';
            break;
          case TreasureType.event:
            iconPath = 'assets/images/activity/ico_treasure_event_fixed.svg';
            break;
        }
        break;
    }
    return iconPath;
  }
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
  @JsonValue('DELETED')
  deleted,
}

enum TreasureType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('EVENT')
  event;

  String getTypeForBottomSheet() {
    switch (this) {
      case TreasureType.normal:
        return 'normal_treasure'.tr();
      case TreasureType.event:
        return 'event_treasure'.tr();
    }
  }
}
