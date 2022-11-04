import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

class LeaderboardHome extends StatelessWidget {
  const LeaderboardHome({Key? key}) : super(key: key);

  Widget showBottomCalender(context, controller) {
    return Obx(() {
      return Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0xFF363841),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: TableCalendar(
          locale: 'ko-KR',
          firstDay: controller.firstDay.value!,
          lastDay: controller.lastDay.value!,
          focusedDay: controller.selectedDate.value!,
          selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate.value!),
          headerStyle: const HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            leftChevronPadding: EdgeInsets.only(left: 60, top: 10, bottom: 10),
            rightChevronPadding: EdgeInsets.only(right: 60, top: 10, bottom: 10),
          ),
          calendarFormat: controller.calendarFormat,
          calendarStyle: CalendarStyle(
            /*todayDecoration: BoxDecoration(
                color: const Color(0xFF0EE6F3),
                shape: BoxShape.circle,
                border: Border.all(
                    width: 14,
                    style: BorderStyle.solid,
                    color: const Color(0xFF363841),
                    strokeAlign: StrokeAlign.center
                )
            ),*/
            todayTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
            defaultTextStyle: const TextStyle(color: Colors.white),
            weekendTextStyle: const TextStyle(color: Colors.white),
            selectedDecoration: BoxDecoration(
                color: const Color(0xFF0EE6F3), shape: BoxShape.circle, border: Border.all(width: 14, style: BorderStyle.solid, color: const Color(0xFF363841), strokeAlign: StrokeAlign.center)),
            selectedTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
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
      height: 90,
      color: const Color(0xFF08080B),
      padding: const EdgeInsets.only(top: 8, left: 11, right: 17, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          iconMyRankArrow,
          SizedBox(
            width: 20,
            child: Text(
              myRank.rank.toString(),
              style: const TextStyle(color: Color(0xFF0EE6F3), fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 4)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                (myRank.profileImageUrl != '')
                    ? Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: const Color(0xFF0EE6F3),
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 15,
                            foregroundImage: NetworkImage(myRank.profileImageUrl),
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    (myRank.nickname.contains('@') ? myRank.nickname.substring(0, myRank.nickname.indexOf('@')) : myRank.nickname),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
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
                '${myRank.rewardGo.toString()} GO',
                textAlign: TextAlign.right,
                fontSize: 14,
                fontWeight: 600,
              ),
              const Padding(padding: EdgeInsets.only(top: 7)),
              StyledText(
                '${formatDecimalPlaces(myRank.rewardTik, 1)} TIK',
                textAlign: TextAlign.right,
                color: const Color(0xFFbababa),
                fontSize: 14,
                fontWeight: 500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderRanker(RankerModel ranker, int index) {
    return Container(
      color: const Color(0xFF1D1D26),
      height: 58,
      padding: const EdgeInsets.only(top: 8, left: 18, right: 17, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              ranker.rank.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 12)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                (ranker.profileImageUrl != '')
                    ? CircleAvatar(
                        radius: 15,
                        foregroundImage: NetworkImage(ranker.profileImageUrl),
                      )
                    : const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text((ranker.nickname.contains('@') ? ranker.nickname.substring(0, ranker.nickname.indexOf('@')) : ranker.nickname),
                      overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.left),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: StyledText(
                    '${formatDecimalPlaces(ranker.rewardTik, 1)} TIK',
                    textAlign: TextAlign.right,
                    fontSize: 14,
                    lineHeight: 14,
                    fontWeight: 500,
                    color: const Color(0xFFBABABA),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: StyledText(
            '오늘의 GO',
            color: Color(0xFF0EE6F3),
            fontWeight: 700,
            fontSize: 24,
            lineHeight: 32,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 23.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconStatisticsTokenGo,
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Row(
                        children: [
                          StyledText(
                            '${activityController.userState.value.state != null ? formatDecimalPlaces(activityController.userState.value.state!.dailyGoReward!, 2) : 0}',
                            color: Colors.white,
                            fontWeight: 600,
                            fontSize: 30,
                            lineHeight: 28,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: StyledText(
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
          margin: const EdgeInsets.only(top: 18, left: 18, right: 22),
          decoration: BoxDecoration(
            color: const Color(0xFF2E3038),
            border: Border.all(
              width: 1,
              color: const Color(0xFF2E3038),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                      const StyledText(
                        'TIK 획득내역',
                        color: Color(0xFF0EE6F3),
                        fontWeight: 400,
                        fontSize: 14,
                        lineHeight: 21,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.5),
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
          padding: const EdgeInsets.only(top: 38, left: 25, right: 18, bottom: 12),
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
                  showBarModalBottomSheet(
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
                        color: const Color(0xFFBFBFBF),
                        fontSize: 12,
                        fontWeight: 600,
                      );
                    }),
                    //StyledText(controller.leaderboardDate.value!, color: const Color(0xFF747474), fontSize: 12, fontWeight: 600,),
                    const Padding(padding: EdgeInsets.only(left: 8)),
                    iconCalendar
                    //Text(controller.formattedDate.value)
                  ],
                ),
              )
            ],
          ),
        ),
        Obx(() {
          return (controller.myRank.value != null) ? renderMyRank(controller) : Container();
        }),
        Expanded(
          child: PagedListView<int, RankerModel>.separated(
            pagingController: controller.pagingController,
            separatorBuilder: (context, index) => const Divider(
              thickness: 2,
              indent: 0,
              endIndent: 0,
              height: 1,
              color: Color(0xFF26272F),
            ),
            builderDelegate: PagedChildBuilderDelegate<RankerModel>(
              itemBuilder: (context, item, index) => (renderRanker(item, index)),
              noItemsFoundIndicatorBuilder: (context) => Center(

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/images/wallet/ico_empty.svg'),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: StyledText(
                        '랭킹 기록이 없어요.',
                        color: Color(0xff7b7b7b),
                        fontSize: 16,
                        lineHeight: 10,
                        fontWeight: 500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
