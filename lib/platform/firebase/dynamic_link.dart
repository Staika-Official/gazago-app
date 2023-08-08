import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

Future<void> initDynamicLink() async {
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    Get.toNamed(initialLink.link.path);
  }

  listenToDynamicLink();
}

void listenToDynamicLink() {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
    Map<String, String> queryParams = dynamicLinkData.link.queryParameters;
    if (queryParams['route'] != null) {
      Get.toNamed(queryParams['route']!);
    }
  }).onError((error) {
    // Handle errors
  });
}
