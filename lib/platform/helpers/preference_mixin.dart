
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';


mixin PreferenceMixin {
  final Rx<UserAccountModel> profile = Rx(
    UserAccountModel(
      id: -1,
      login: '',
      email: '',
      nickname: '',
      profileImageUrl: '',
      provider: '',
      availableChangeNickname: false,
      authorities: HiveStore.load(key: HiveKey.authorities.name) ?? [''],
    ),
  );

  final RxString originalNickname = RxString('');

  Future<void> getProfileInfo() async {
    await MemberService.getMemberUserInfo(
      successCallback: (account) {
        profile.update(
              (state) {
            state?.nickname = account.nickname;
            state?.profileImageUrl = account.profileImageUrl;
            state?.availableChangeNickname = account.availableChangeNickname;
            state?.provider = account.provider;
            state?.email = account.email;
            state?.id = account.id;
          },
        );
        originalNickname.value = account.nickname!;
      }, errorCallback: (message) {
        showToastPopup(message);
      },
    );
  }

  // void getUserInfo() async {
  //   await UaaService.getUserInfo(
  //     successCallback: (UserAccountModel account) {
  //
  //       profile.update(
  //             (state) {
  //           state?.nickname = account.nickname;
  //           state?.profileImageUrl = account.profileImageUrl;
  //           state?.availableChangeNickname = account.availableChangeNickname;
  //           state?.email = account.email;
  //           state?.id = account.id;
  //           // state?.provider = previousProfile.value!.provider;
  //           state?.userId = account.userId;
  //         },
  //       );
  //       print(profile.value.toJson());
  //       originalNickname.value = account.nickname!;
  //     },
  //   );
  // }
}
