import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bs;
import 'package:table_calendar/table_calendar.dart';

class LeaderboardHome extends StatelessWidget {
  const LeaderboardHome({Key? key}) : super(key: key);

  Widget showBottomCalender(context, controller) {
    return Obx(() {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: subBg01Color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
        ),
        child: TableCalendar(
          locale: 'ko-KR',
          firstDay: controller.firstDay.value!,
          lastDay: controller.lastDay.value!,
          focusedDay: controller.selectedDate.value!,
          selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate.value!),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500),
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            leftChevronPadding: EdgeInsets.only(left: 60.sp, top: 10.sp, bottom: 10.sp),
            rightChevronPadding: EdgeInsets.only(right: 60.sp, top: 10.sp, bottom: 10.sp),
          ),
          calendarFormat: controller.calendarFormat,
          calendarStyle: CalendarStyle(
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
            todayTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0.sp,
            ),
            defaultTextStyle: const TextStyle(color: Colors.white),
            weekendTextStyle: const TextStyle(color: Colors.white),
            selectedDecoration:
                BoxDecoration(color: skyBlueColor, shape: BoxShape.circle, border: Border.all(width: 14.sp, style: BorderStyle.solid, color: popupBgColor, strokeAlign: BorderSide.strokeAlignCenter)),
            selectedTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0.sp,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            controller.calendarSelectedChanged(selectedDay);
            Navigator.of(context).pop();
          },
          onPageChanged: (focusedDay) {
            //controller.calendarChanged(focusedDay);
          },
        ),
      );
    });
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
          SizedBox(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                child: Text(
                  myRank.rank.toString(),
                  style: TextStyle(
                    color: skyBlueColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 4.sp)),
          Expanded(
            flex: 2,
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
      height: 58.sp,
      padding: EdgeInsets.only(top: 8.sp, left: 18.sp, right: 17.sp, bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ranker.rank.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 12.sp)),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                (ranker.profileImageUrl != null)
                    ? CircleAvatar(
                        radius: 15.sp,
                        foregroundImage: NetworkImage(ranker.profileImageUrl!),
                      )
                    : CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: Colors.white,
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.sp),
                  child: Text((ranker.nickname.contains('@') ? ranker.nickname.substring(0, ranker.nickname.indexOf('@')) : ranker.nickname),
                      overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.left),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StyledText(
                  '${formatDecimalPlaces(ranker.rewardGo, 2)} GO',
                  textAlign: TextAlign.right,
                  fontSize: 14,
                  lineHeight: 14,
                  fontWeight: 600,
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
                    color: const Color(0xFFBABABA),
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeaderboardController controller = Get.put(LeaderboardController());
    ActivityController activityController = Get.find();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.sp),
            child: StyledText(
              '오늘의 GO',
              color: skyBlueColor,
              fontWeight: 700,
              fontSize: 24,
              lineHeight: 32,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.0.sp, top: 6.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconStatisticsTokenGo,
                Padding(
                  padding: EdgeInsets.only(left: 10.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Row(
                          children: [
                            StyledText(
                              activityController.userState.value.state != null ? formatDecimalPlaces(activityController.userState.value.state!.dailyGoReward!, 2) : formatDecimalPlaces(0, 2),
                              color: Colors.white,
                              fontWeight: 600,
                              fontSize: 30,
                              lineHeight: 28,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.0.sp),
                              child: const StyledText(
                                'GO',
                                color: Colors.white,
                                fontWeight: 500,
                                fontSize: 18,
                                lineHeight: 20,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
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
              padding: EdgeInsets.all(20.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      StyledText(
                        'TIK은 매일 자정(KST)에 배분됩니다.',
                        color: Colors.white,
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 21,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => controller.goPageCalendarStatistics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StyledText(
                          'TIK 획득내역',
                          color: skyBlueColor,
                          fontWeight: 400,
                          fontSize: 14,
                          lineHeight: 21,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.5.sp),
                          child: iconLeaderboardRightArrow,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 38.sp, left: 25.sp, right: 18.sp, bottom: 12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const StyledText(
                  '리더보드',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: 600,
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
                            controller: controller.scroll,
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
                          )),
                        ],
                      ),
          )
        ],
      );
    });
  }
}
