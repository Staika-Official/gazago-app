import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:get/get.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoaderController loaderController = Get.find();
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.3),
      body: Stack(
        children: [
          Center(
            key: loaderController.dialogKey,
            child: const CircularProgressIndicator(), //무지성 돌돌이~
          ),
        ],
      ),
    );
  }
}
