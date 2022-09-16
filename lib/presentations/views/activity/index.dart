import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';

class ActivityHome extends StatelessWidget {
  ActivityHome({Key? key}) : super(key: key);

  List<Widget> renderStatList(ActivityController controller) {
    return controller.statList.map((stat) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(stat.name), Text('${stat.currentStat.toString()}/100')],
            ),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      minHeight: 20,
                      value: stat.currentStat / 100,
                    ),
                  ),
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.add_circle),
                ),
              ],
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> renderActivitySumList(ActivityController controller) {
    return controller.activitySumList
        .map(
          (activitySum) => Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activitySum['title']),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(activitySum['content']),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.put(ActivityController());
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  foregroundImage: NetworkImage('https://placeimg.com/20/20/any'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${'2,000.00'} GO',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          '내가 획득한 STEP',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Obx(() {
            return Column(
              children: [
                ...renderStatList(controller),
              ],
            );
          }),
          Obx(() {
            return GridView.count(
              childAspectRatio: 1 / .4,
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: [
                ...renderActivitySumList(controller),
              ],
            );
          }),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: MaterialButton(
                    onPressed: () => null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color: Colors.blue,
                    height: 100,
                    minWidth: 100,
                    child: const Text('Go'),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () => null,
                    child: const Icon(Icons.terrain),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
