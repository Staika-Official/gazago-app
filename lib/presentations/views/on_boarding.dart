import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

import '../../platform/controllers/onboarding_controller.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  List<Widget> _getImageSliders(OnBoardingController controller) {
    return controller.imgList
        .map((item) => Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: item['height'],
                ),
                child: Center(
                  child: Image.asset(
                    item['path'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _getTextList(controller) {
    return List.generate(_getImageSliders(controller).length, (index) {
      return Opacity(
        opacity: controller.ops[index],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: index != _getImageSliders(controller).length - 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                StyledText(
                  controller.getText(index)['title'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    controller.getText(index)['content'],
                    textAlign: index != _getImageSliders(controller).length - 1 ? TextAlign.left : TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 28 / 18,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final CarouselSliderController carouselController = CarouselSliderController();
    final OnBoardingController controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  carouselController.animateToPage(controller.pageSize - 1);
                },
                style: ButtonStyle(
                  alignment: Alignment.centerRight,
                  foregroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 165, 165, 165)),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20.sp)),
                ),
                child: const Text('건너뛰기'),
              ),
            ),
            Expanded(
              child: CarouselSlider(
                key: const Key('Slider'),
                items: _getImageSliders(controller),
                controller: carouselController,
                options: CarouselOptions(
                  viewportFraction: 3,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height,
                  onPageChanged: (index, reason) {
                    controller.setCurrent(index);
                  },
                  onScrolled: (op) {
                    controller.setValue(op!);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.sp),
              child: Obx(() {
                return Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    ..._getTextList(context),
                  ],
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Obx(() {
                    return Container(
                      width: 25.0.sp,
                      height: 3.0.sp,
                      margin: EdgeInsets.only(top: 32.sp, left: 7.0.sp, right: 7.0.sp, bottom: 43.sp),
                      decoration: BoxDecoration(shape: BoxShape.rectangle, color: controller.current.value == entry.key ? const Color.fromRGBO(0, 0, 0, 1) : const Color.fromRGBO(0, 0, 0, 0.31)),
                    );
                  }),
                );
              }).toList(),
            ),
            Container(
              height: 60.sp,
              width: double.infinity,
              margin: EdgeInsets.only(left: 15.sp, right: 15.sp, bottom: 20.sp),
              child: Obx(() {
                return Visibility(
                  // visible: _controller.current.value == _controller.pageSize - 1,
                  visible: controller.ops[controller.pageSize - 1] > 0.9,
                  child: ElevatedButton(
                      key: const Key('next'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('스타이카 시작하기'),
                      onPressed: () {
                        controller.nextStep();
                      }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
