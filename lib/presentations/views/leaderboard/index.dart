import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/leaderboard/calendar_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bs;
import 'package:table_calendar/table_calendar.dart';

class LeaderboardHome extends StatelessWidget {
  const LeaderboardHome({Key? key}) : super(key: key);

  Widget showBottomCalender(BuildContext context, LeaderboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: popupBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),
      child: SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 28.0.sp),
              child: Obx(() {
                return TableCalendar(
                  rowHeight: 94,
                  daysOfWeekHeight: 30,
                  locale: 'ko-KR',
                  firstDay: controller.firstDay.value!,
                  lastDay: controller.lastDay.value!,
                  focusedDay: controller.selectedDate.value!,
                  selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate.value!),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E().format(day);

                      if (day.weekday == DateTime.sunday || day.weekday == DateTime.saturday) {
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Color(0xFFB5BEC6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFFB5BEC6),
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, date, focusedDate) {
                      return CalendarCell(
                        date: date,
                        cellType: CalendarCellType.monthDay,
                        controller: controller,
                      );
                    },
                    selectedBuilder: (context, date, focusedDate) {
                      return CalendarCell(
                        date: date,
                        cellType: CalendarCellType.focusedDay,
                        controller: controller,
                      );
                    },
                    todayBuilder: (context, date, focusedDate) {
                      return CalendarCell(
                        date: date,
                        cellType: CalendarCellType.today,
                        controller: controller,
                      );
                    },
                    outsideBuilder: (context, date, focusedDate) {
                      return CalendarCell(
                        date: date,
                        cellType: CalendarCellType.outsideDay,
                        controller: controller,
                      );
                    },
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500),
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                    headerPadding: EdgeInsets.only(top: 30.sp, bottom: 20.sp),
                    leftChevronPadding: EdgeInsets.only(left: 60.sp, top: 10.sp, bottom: 10.sp),
                    rightChevronPadding: EdgeInsets.only(right: 60.sp, top: 10.sp, bottom: 10.sp),
                  ),
                  calendarFormat: controller.calendarFormat,
                  calendarStyle: const CalendarStyle(
                      /*todayDecoration: BoxDecoration(
                                color: skyBlueColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 14,
                                    style: BorderStyle.solid,
                                    color: popupBgColor,
                                    strokeAlign: StrokeAlign.center
                                )
                            ),*/
                      ),
                  onDaySelected: (selectedDay, focusedDay) {
                    controller.calendarSelectedChanged(selectedDay);
                    Navigator.of(context).pop();
                  },
                  onPageChanged: (focusedDay) {
                    controller.calendarChanged(focusedDay);
                  },
                );
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 30,
                ),
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 12,
                  top: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: subBg01Color,
                ),
                child: Column(
                  children: [
                    StyledText(
                      'TOTAL',
                      fontSize: 14,
                      lineHeight: 20,
                      fontWeight: 600,
                      letterSpacing: 3,
                      color: lightGrayColor,
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                iconTikCalendar,
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text.rich(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      height: 20.sp / 16.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                      color: tikColor,
                                    ),
                                    TextSpan(
                                      text: formatDecimalPlaces(controller.totalTikRewarded.value.toDouble(), 0),
                                      children: [
                                        TextSpan(text: ' TIK', style: TextStyle(fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  iconStikCalendar,
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text.rich(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        height: 20.sp / 16.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                        color: stikColor,
                                      ),
                                      TextSpan(
                                        text: formatDecimalPlaces(controller.totalStikRewarded.value, 2),
                                        children: [
                                          TextSpan(text: ' STIK', style: TextStyle(fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderMyRank(LeaderboardController controller) {
    RankerModel myRank = controller.myRank.value!;
    return Container(
      width: double.maxFinite,
      height: 90.sp,
      color: deepBlackColor,
      padding: EdgeInsets.only(top: 8.sp, left: 11.sp, right: 17.sp, bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          iconMyRankArrow,
          // SizedBox(
          //   width: 20,
          //   child: Text(
          //     myRank.rank.toString(),
          //     style: TextStyle(color: skyBlueColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60, minWidth: 60),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  myRank.rank!.toString(),
                  style: TextStyle(color: skyBlueColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                (myRank.profileImageUrl != null)
                    ? Container(
                        width: 44.0.sp,
                        height: 44.0.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0.sp)),
                          border: Border.all(
                            color: skyBlueColor,
                            width: 1.5.sp,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 15.sp,
                            foregroundImage: NetworkImage(myRank.profileImageUrl!),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: Colors.white,
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.sp),
                  child: Text(
                    (myRank.nickname.contains('@') ? myRank.nickname.substring(0, myRank.nickname.indexOf('@')) : myRank.nickname),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StyledText(
                '${formatDecimalPlaces(myRank.rewardGo, 2)} GO',
                textAlign: TextAlign.right,
                fontSize: 14,
                fontWeight: 600,
              ),
              Padding(padding: EdgeInsets.only(top: 7.sp)),
              StyledText(
                '${formatDecimalPlaces(myRank.rewardTik, 0)} TIK',
                textAlign: TextAlign.right,
                color: deepGrayColor,
                fontSize: 14,
                fontWeight: 500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderRanker(RankerModel ranker, BuildContext context) {
    return Container(
      color: subBg01Color,
      height: 65.sp,
      padding: EdgeInsets.only(left: 18.sp, right: 17.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 40, minWidth: 40),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  ranker.rank!.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (ranker.profileImageUrl != null)
                      ? SizedBox(
                          width: 50.0.sp,
                          height: 50.0.sp,
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 7.0),
                                  child: CircleAvatar(
                                    radius: 16.sp,
                                    foregroundImage: (ranker.profileImageUrl == null || ranker.profileImageUrl == '')
                                        ? Image.asset(
                                            'assets/images/ic_launcher.png',
                                            width: 30.sp,
                                          ).image
                                        : NetworkImage(ranker.profileImageUrl!),
                                  ),
                                ),
                              ),
                              if (ranker.rank! < 11)
                                Center(
                                  child: SizedBox(
                                    width: 50.sp,
                                    height: 50.sp,
                                    child: Image.asset(
                                      'assets/images/leaderboard/ranker_${ranker.rank}.png',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : CircleAvatar(
                          radius: 16.sp,
                          backgroundColor: Colors.white,
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (ranker.nickname.contains('@')
                              ? ranker.nickname.substring(
                                  0,
                                  ranker.nickname.indexOf('@'),
                                )
                              : ranker.nickname),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        if (ranker.rank! < 11)
                          Padding(
                            padding: EdgeInsets.only(top: 4.0.sp),
                            child: Text.rich(
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 10.sp,
                                height: 11.sp / 10.sp,
                                fontWeight: FontWeight.w700,
                                color: skyBlueColor,
                              ),
                              TextSpan(
                                text: '${ranker.additionStik != null ? ranker.additionStik : '0'}',
                                children: [
                                  const TextSpan(
                                      text: ' STIK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      )),
                                  const TextSpan(text: ' + '),
                                  TextSpan(
                                      text: '${formatDecimalPlaces(ranker.additionTik ?? 0, 0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const TextSpan(
                                      text: ' TIK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      )),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StyledText(
                '${formatDecimalPlaces(ranker.rewardGo, 2)} GO',
                textAlign: TextAlign.right,
                fontSize: 14,
                lineHeight: 14,
                fontWeight: 600,
                letterSpacing: -.1,
                softWrap: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.sp),
                child: StyledText(
                  '${formatDecimalPlaces(ranker.rewardTik, 0)} TIK',
                  textAlign: TextAlign.right,
                  fontSize: 14,
                  lineHeight: 14,
                  fontWeight: 500,
                  letterSpacing: -.1,
                  color: const Color(0xFFBABABA),
                  softWrap: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeaderboardController controller = Get.put(LeaderboardController());

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0.sp),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.sp, right: 10.sp),
                  child: StyledText(
                    '오늘의 리워드',
                    color: Colors.white,
                    fontWeight: 700,
                    fontSize: 24.sp,
                    lineHeight: 32.sp,
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => showLeaderboardInfo(),
                    icon: iconInfo,
                    splashRadius: 15.sp,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 18.sp, left: 18.sp, right: 22.sp),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3038),
              border: Border.all(
                width: 1,
                color: const Color(0xFF2E3038),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12.sp),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconTodayTik,
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StyledText(
                                controller.todayTikAmount.value > 0 ? formatDecimalPlaces(controller.todayTikAmount.value, 0) : 0.toString(),
                                color: Colors.white,
                                fontWeight: 600,
                                fontSize: 30,
                                lineHeight: 34,
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: 2.0.sp),
                              //   child: const StyledText(
                              //     'TIK',
                              //     color: Colors.white,
                              //     fontWeight: 500,
                              //     fontSize: 18,
                              //     lineHeight: 20,
                              //   ),
                              // ),
                            ],
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.sp, left: 18.sp, right: 18.sp),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.0.sp),
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: deepGrayColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text.rich(
                        style: TextStyle(
                          color: deepGrayColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                        TextSpan(
                          text: '리더보드 참여자 모두에게 획득한 GO만큼 ',
                          children: [
                            TextSpan(
                                text: '오늘의 리워드를',
                                style: TextStyle(
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            TextSpan(text: ' 모두 분배해요.')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: deepGrayColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text.rich(
                        style: TextStyle(
                          color: deepGrayColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '오늘의 리워드',
                                style: TextStyle(
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            TextSpan(text: '는 확정되었습니다!')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: deepGrayColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text.rich(
                        style: TextStyle(
                          color: deepGrayColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        TextSpan(
                          text: 'TIK은 매일 자정(KST)에 확정되어 분배해요.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 38.sp, left: 25.sp, right: 18.sp, bottom: 12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const StyledText(
                      '리더보드',
                      color: Colors.white,
                      fontSize: 20,
                      lineHeight: 20,
                      fontWeight: 600,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: StyledText(
                        controller.checkRewardDate.value,
                        color: deepGrayColor,
                        fontSize: 12,
                        lineHeight: 12,
                        fontWeight: 500,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => {
                    bs.showBarModalBottomSheet(
                      context: context,
                      builder: (context) => showBottomCalender(context, controller),
                    )
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return StyledText(
                          controller.leaderboardDate.value,
                          color: lightGrayColor,
                          fontSize: 12,
                          fontWeight: 600,
                        );
                      }),
                      //StyledText(controller.leaderboardDate.value!, color: const Color(0xFF747474), fontSize: 12, fontWeight: 600,),
                      Padding(padding: EdgeInsets.only(left: 8.sp)),
                      iconCalendar
                      //Text(controller.formattedDate.value)
                    ],
                  ),
                )
              ],
            ),
          ),
          (controller.myRank.value != null) ? renderMyRank(controller) : Container(),
          Expanded(
            child: controller.dataGetLoading.value
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : controller.rankings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            iconEmpty,
                            Padding(
                              padding: EdgeInsets.only(top: 20.sp),
                              child: const StyledText(
                                '랭킹 기록이 없어요.',
                                color: Color(0xff7b7b7b),
                                fontSize: 16,
                                lineHeight: 10,
                                fontWeight: 500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ListView.separated(
                              controller: controller.leaderboardScrollController,
                              separatorBuilder: (context, index) => const Divider(
                                thickness: 2,
                                indent: 0,
                                endIndent: 0,
                                height: 1,
                                color: Color(0xFF26272F),
                              ),
                              itemCount: controller.rankings.length + 1,
                              itemBuilder: (context, index) {
                                if (index < controller.rankings.length) {
                                  return renderRanker(controller.rankings[index], context);
                                } else {
                                  return (controller.hasMore.value) ? Padding(padding: EdgeInsets.symmetric(vertical: 20.0.sp), child: const Center(child: CircularProgressIndicator())) : Container();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
          )
        ],
      );
    });
  }
}
