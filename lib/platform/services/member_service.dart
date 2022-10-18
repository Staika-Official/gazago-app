import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/member.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class MemberService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<void> initializeUserData(String nickname, String profileImageUrl) async {
    await MemberApi.initializeUserData(userId!, nickname!, profileImageUrl!);
  }
}
