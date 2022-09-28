import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class BadgeService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);
}
