import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';

class TreasureHuntingDurationWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const TreasureHuntingDurationWidget({
    super.key,
    this.startDate,
    this.endDate,
  });

  /// Check if both dates are available
  bool get hasValidDates => startDate != null && endDate != null;

  /// Check if the event should be visible (not expired)
  bool get shouldShow {
    if (!hasValidDates) return false;

    final now = DateTime.now();
    return now.isBefore(endDate!);
  }

  /// Format dates in Korean format (YYYY-MM-DD)
  String get formattedDuration {
    if (!hasValidDates) return '';

    final startFormatted = _formatDate(startDate!);
    final endFormatted = _formatDate(endDate!);

    return '$startFormatted - $endFormatted';
  }

  /// Format a single date in YYYY-MM-DD format
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Only show widget if dates are valid and event hasn't expired
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          formattedDuration,
          style: TextStyle(
            color: deepGrayColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            height: 10.sp / 10.sp,
            letterSpacing: 0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
