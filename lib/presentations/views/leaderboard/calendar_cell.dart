import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/daily_reward_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:intl/intl.dart';

class CalendarCell extends StatelessWidget {
  final CalendarCellType cellType;
  final DateTime date;
  final LeaderboardController controller;
  const CalendarCell({
    super.key,
    this.cellType = CalendarCellType.monthDay,
    required this.date,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    DailyRewardModel dailyReward = controller.dailyRewardList.singleWhere((reward) {
      return DateFormat('yyyy-MM-dd').format(reward.rewardedDate!) == DateFormat('yyyy-MM-dd').format(date);
    }, orElse: () => DailyRewardModel(id: -1));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: [CalendarCellType.today, CalendarCellType.focusedDay].any((element) => element == cellType)
                ? BoxDecoration(
                    color: CalendarCellType.focusedDay == cellType ? skyBlueColor : skyBlueColor.withOpacity(0.8),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Center(
              child: StyledText(
                date.day.toString(),
                fontSize: 16.sp,
                lineHeight: 18.sp,
                fontWeight: 600,
                color: cellType == CalendarCellType.monthDay
                    ? Colors.white
                    : cellType == CalendarCellType.outsideDay
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black,
              ),
            ),
          ),
          if (dailyReward.tikAmount != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: StyledText(
                '+${formatDecimalPlaces(dailyReward.tikAmount!.toDouble(), 0)}',
                fontSize: 12.sp,
                lineHeight: 16.sp,
                fontWeight: 600,
                color: tikColor,
              ),
            ),
          if (dailyReward.stikAmount != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: StyledText(
                '+${formatDecimalPlaces(dailyReward.stikAmount!, 2)}',
                fontSize: 12.sp,
                lineHeight: 16.sp,
                fontWeight: 600,
                color: stikColor,
              ),
            ),
        ],
      ),
    );
  }
}
