import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class CalendarCell extends StatelessWidget {
  final CalendarCellType cellType;
  final DateTime date;
  // final LeaderboardController controller;

  const CalendarCell({
    super.key,
    this.cellType = CalendarCellType.monthDay,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // LeaderboardController leaderboardController = Get.put(LeaderboardController());
    // print('showBottom${leaderboardController.dailyRewardList}');
    // UserRewardStatisticsModel dailyReward = controller.dailyRewardList.singleWhere((reward) {
    //   return DateFormat('yyyy-MM-dd').format(DateTime.parse(reward.date!)) == DateFormat('yyyy-MM-dd').format(date);
    // }, orElse: () => UserRewardStatisticsModel(id: -1));
    // print(dailyReward.toJson());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: [CalendarCellType.today, CalendarCellType.focusedDay].any((element) => element == cellType)
                ? BoxDecoration(
                    color: CalendarCellType.focusedDay == cellType ? skyBlueColor : Colors.black,
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
                        : cellType == CalendarCellType.today
                            ? skyBlueColor
                            : Colors.black,
              ),
            ),
          ),
          // if (dailyReward.tik != null)
          //   FittedBox(
          //     fit: BoxFit.scaleDown,
          //     child: Column(
          //       children: [
          //         StyledText(
          //           '+${formatDecimalPlaces(dailyReward.tik!.toDouble(), 0)}',
          //           fontSize: 12.sp,
          //           lineHeight: 16.sp,
          //           fontWeight: 600,
          //           color: tikColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // if (dailyReward.stik != null)
          //   FittedBox(
          //     fit: BoxFit.scaleDown,
          //     child: StyledText(
          //       '+${formatDecimalPlaces(dailyReward.stik!, 2)}',
          //       fontSize: 12.sp,
          //       lineHeight: 16.sp,
          //       fontWeight: 600,
          //       color: stikColor,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
