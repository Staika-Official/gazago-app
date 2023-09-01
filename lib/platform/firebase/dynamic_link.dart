import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';

Future<void> initDynamicLink() async {
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    Map<String, String> queryParams = initialLink.link.queryParameters;
    if (queryParams['route'] != null) {
      handleRoute(queryParams['route']!);
    }
  }

  listenToDynamicLink();
}

void listenToDynamicLink() {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
    Map<String, String> queryParams = dynamicLinkData.link.queryParameters;
    if (queryParams['route'] != null) {
      handleRoute(queryParams['route']!);
    }
  }).onError((error) {
    // Handle errors
  });
}
