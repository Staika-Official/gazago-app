import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/password_mixin.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class ConfirmWalletPasswordController extends GetxController with PasswordMixin {
  final RxString _password = ''.obs;
  final Rx<ErrorStatus> _errorStatus = Rx(ErrorStatus.basic);

  final Rx<FormStatus> passwordFormStatus = Rx(FormStatus.empty);
  final RxBool isEnableNext = false.obs;
  final Rx<ErrorStatus> errorMsg = Rx(ErrorStatus.basic);

  void isEnableNextStep() {
    passwordFormStatus.listen((status) {
      setErrorState(status, _errorStatus.value);
      isEnableNext.value = passwordFormStatus.value == FormStatus.sufficient;
    });
  }

  Stream<ErrorStatus> getErrorStatusStream() {
    return _errorStatus.stream;
  }

  String getPassword() {
    return _password.value;
  }

  @override
  void onInit() {
    super.onInit();
    isEnableNextStep();
    _errorStatus.listen((event) {
      errorMsg.value = event;
    });
  }

  void updatePassword(String password) {
    _password.value = password;
    passwordFormStatus.value = verifyPassword(password);
  }

  String? nextStep() {
    String? secretKey = HiveStore.loadString(key: HiveKey.solanaSecretKey.name);
    String? email = HiveStore.loadString(key: HiveKey.email.name);
    String? decryptPrivateKey = decrypt(secretKey!, email!, _password.value);
    print('decryptPrivateKey: $decryptPrivateKey');
    print('email: $email');
    print('_password: ${_password.value}');

    if (decryptPrivateKey != null) {
      Get.back();
      return _password.value;
    } else {
      showToastPopup('비밀번호를 다시 확인해주세요');
      return '';
    }
  }
}
