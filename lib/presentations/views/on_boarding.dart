import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text('On Boarding'),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.joinTerms),
              child: const Text('To Join'),
            ),
          ),
        ],
      ),
    );
  }
}
