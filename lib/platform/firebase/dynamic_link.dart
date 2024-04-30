import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

Future<void> initDynamicLink() async {
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  print('initialLink $initialLink');
  if (initialLink != null) {
    print('initialLink $initialLink');
    print('initialLink ${initialLink.link.queryParameters}');
    Map<String, String> queryParams = initialLink.link.queryParameters;
    if (queryParams['route'] != null) {
      handleRoute(queryParams['route']!);
    }

    if (queryParams['inviteId'] != null) {
      HiveStore.save(key: HiveKey.inviteUserId.name, value: queryParams['inviteId']!);
    }
  }

  listenToDynamicLink();
}

void listenToDynamicLink() {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
    print('dynamicLinkData $dynamicLinkData');
    Map<String, String> queryParams = dynamicLinkData.link.queryParameters;
    if (queryParams['route'] != null) {
      handleRoute(queryParams['route']!);
    }

    if (queryParams['inviteId'] != null) {
      HiveStore.save(key: HiveKey.inviteUserId.name, value: queryParams['inviteId']!);
    }
  }).onError((error) {
    // Handle errors
  });
}
