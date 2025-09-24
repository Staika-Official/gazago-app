import 'package:easy_localization/easy_localization.dart';

/// Model for treasure hunting configuration data from API
class TreasureHuntingConfigModel {
  final String treasureHuntTitle;
  final String treasureHuntDescription;
  final DateTime? treasureHuntDurationStart;
  final DateTime? treasureHuntDurationEnd;

  TreasureHuntingConfigModel({
    required this.treasureHuntTitle,
    required this.treasureHuntDescription,
    this.treasureHuntDurationStart,
    this.treasureHuntDurationEnd,
  });

  /// Factory constructor to create model from API response
  factory TreasureHuntingConfigModel.fromJson(List<dynamic> json) {
    String title = 'treasure_hunting_title'.tr();
    String description = 'treasure_hunting_subtitle'.tr();
    DateTime? startDate;
    DateTime? endDate;

    // Parse configuration array from API response
    for (var config in json) {
      if (config is Map<String, dynamic>) {
        final String configKey = config['configKey'] ?? '';
        final String value = config['value'] ?? '';

        switch (configKey) {
          case 'TREASURE_HUNT_TITLE':
            if (value.isNotEmpty && value.trim().isNotEmpty) {
              title = value.trim();
            } else {}
            break;
          case 'TREASURE_HUNT_DESCRIPTION':
            if (value.isNotEmpty && value.trim().isNotEmpty) {
              description = value.trim();
            } else {}
            break;
          case 'TREASURE_HUNT_DURATION_START':
            if (value.isNotEmpty && value.trim().isNotEmpty) {
              startDate = DateTime.parse(value.trim());
            }
            break;
          case 'TREASURE_HUNT_DURATION_END':
            if (value.isNotEmpty && value.trim().isNotEmpty) {
              endDate = DateTime.parse(value.trim());
            }
            break;
        }
      }
    }

    return TreasureHuntingConfigModel(
      treasureHuntTitle: title,
      treasureHuntDescription: description,
      treasureHuntDurationStart: startDate,
      treasureHuntDurationEnd: endDate,
    );
  }

  /// Factory constructor with fallback values
  factory TreasureHuntingConfigModel.fallback() {
    return TreasureHuntingConfigModel(
      treasureHuntTitle: 'treasure_hunting_title'.tr(),
      treasureHuntDescription: 'treasure_hunting_subtitle'.tr(),
    );
  }

  /// Check if both start and end dates are available
  bool get isValidDuration {
    return treasureHuntDurationStart != null && treasureHuntDurationEnd != null;
  }

  /// Check if the current date is within the treasure hunting period
  bool get isActive {
    if (!isValidDuration) {
      return true; // If no duration is set, assume always active
    }

    final now = DateTime.now();
    return now.isAfter(treasureHuntDurationStart!) &&
        now.isBefore(treasureHuntDurationEnd!);
  }

  /// Get formatted duration string in Korean format (YYYY-MM-DD)
  String get formattedDuration {
    if (!isValidDuration) return '';

    final startFormatted =
        DateFormat('yyyy-MM-dd').format(treasureHuntDurationStart!);
    final endFormatted =
        DateFormat('yyyy-MM-dd').format(treasureHuntDurationEnd!);

    return '$startFormatted - $endFormatted';
  }

  /// Check if the treasure hunting event should be visible
  /// Hide if the current date is past the end date
  bool get shouldShowEvent {
    if (!isValidDuration) return true; // If no duration is set, always show

    final now = DateTime.now();
    return now.isBefore(treasureHuntDurationEnd!);
  }

  /// Get title with maximum length to prevent UI overflow
  String get displayTitle {
    const maxLength = 50; // Reasonable max for 2 lines at 19sp font size
    if (treasureHuntTitle.length <= maxLength) {
      return treasureHuntTitle;
    }
    return '${treasureHuntTitle.substring(0, maxLength - 3)}...';
  }

  /// Get description with maximum length to prevent UI overflow
  String get displayDescription {
    const maxLength = 80; // Reasonable max for 2 lines at 11sp font size
    if (treasureHuntDescription.length <= maxLength) {
      return treasureHuntDescription;
    }
    return '${treasureHuntDescription.substring(0, maxLength - 3)}...';
  }

  @override
  String toString() {
    return 'TreasureHuntingConfigModel(title: $treasureHuntTitle, description: $treasureHuntDescription, start: $treasureHuntDurationStart, end: $treasureHuntDurationEnd)';
  }
}
