import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';

class HowToGo extends StatelessWidget {
  const HowToGo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController activityController = Get.find();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: InAppWebView(
            key: activityController.webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(F.howToGoUrl)),
            initialSettings: InAppWebViewSettings(
              disableContextMenu: true,
              javaScriptEnabled: true,
            ),
          ),
        ),
      ),
    );
  }
}
