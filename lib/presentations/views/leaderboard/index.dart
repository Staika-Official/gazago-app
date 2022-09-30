import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:get/get.dart';

class LeaderboardHome extends StatelessWidget {
  const LeaderboardHome({Key? key}) : super(key: key);

  List<Widget> renderRankerList(LeaderboardController controller) {
    return controller.rankerList
        .map(
          (ranker) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    ranker.id!.toString(), // TODO. 추후 orderby로 변경
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        foregroundImage: NetworkImage(ranker.profileImageUrl),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(ranker.nickname),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ranker.rewardGo.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ranker.rewardTik.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    LeaderboardController controller = Get.put(LeaderboardController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('획득한 STEP'),
              Text('${1000.toString()} GO'),
              Text('예상 보상량: ${100.toString()}TIK'),
              const Text('정산까지 남은 시간 ${'02:20'}'),
              const LinearProgressIndicator(
                value: 0.4,
              )
            ],
          ),
        ),
        const Text(
          '리더보드',
          textAlign: TextAlign.left,
        ),
        Obx(() {
          return InkWell(
            onTap: () => controller.showCalendar(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.calendar_month), Text(controller.formattedDate.value)],
            ),
          );
        }),
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              child: Obx(() {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '#',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '닉네임',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'GO',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'TIK',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...renderRankerList(controller),
                  ],
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}
