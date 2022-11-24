import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

import '../../platform/controllers/onboarding_controller.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  List<Widget> _getImageSliders(_controller) {
    return _controller.imgList
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

  List<Widget> _getTextList(_controller) {
    return List.generate(_getImageSliders(_controller).length, (index) {
      return Opacity(
        opacity: _controller.ops[index],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: index != _getImageSliders(_controller).length - 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                StyledText(
                  _controller.getText(index)['title'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _controller.getText(index)['content'],
                    textAlign: index != _getImageSliders(_controller).length - 1 ? TextAlign.left : TextAlign.center,
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
    final CarouselController _ccontroller = CarouselController();
    final OnBoardingController _controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _ccontroller.animateToPage(_controller.pageSize - 1);
                },
                style: ButtonStyle(
                  alignment: Alignment.centerRight,
                  foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 165, 165, 165)),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20.sp)),
                ),
                child: const Text('건너뛰기'),
              ),
            ),
            Expanded(
              child: CarouselSlider(
                key: const Key('Slider'),
                items: _getImageSliders(_controller),
                carouselController: _ccontroller,
                options: CarouselOptions(
                  viewportFraction: 3,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height,
                  onPageChanged: (index, reason) {
                    _controller.setCurrent(index);
                  },
                  onScrolled: (op) {
                    _controller.setValue(op!);
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
              children: _controller.imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _ccontroller.animateToPage(entry.key),
                  child: Obx(() {
                    return Container(
                      width: 25.0.sp,
                      height: 3.0.sp,
                      margin: EdgeInsets.only(top: 32.sp, left: 7.0.sp, right: 7.0.sp, bottom: 43.sp),
                      decoration: BoxDecoration(shape: BoxShape.rectangle, color: _controller.current.value == entry.key ? const Color.fromRGBO(0, 0, 0, 1) : const Color.fromRGBO(0, 0, 0, 0.31)),
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
                  visible: _controller.ops[_controller.pageSize - 1] > 0.9,
                  child: ElevatedButton(
                      key: const Key('next'),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('스타이카 시작하기'),
                      onPressed: () {
                        _controller.nextStep();
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
