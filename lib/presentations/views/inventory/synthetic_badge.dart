import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/synthetic_badge_controller.dart';
import 'package:get/get.dart';

class SyntheticBadge extends StatelessWidget {
  const SyntheticBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeMenuController homeMenuController = Get.find();
    SyntheticBadgeController _controller = Get.put(SyntheticBadgeController());

    return Scaffold(
      appBar: homeMenuController.appbarList[1],
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _controller.showSelectBadgePopup(),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/@temp_badge.png'),
                                foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                                radius: 30,
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/@temp_badge.png'),
                              foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                              radius: 30,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/@temp_badge.png'),
                              foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                              radius: 30,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/@temp_badge.png'),
                              foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                              radius: 30,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/@temp_badge.png'),
                              foregroundImage: CachedNetworkImageProvider('https://placeimg.com/60/60/any'),
                              radius: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => null,
                  child: const Text('합성'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
