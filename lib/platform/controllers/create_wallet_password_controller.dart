import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/password_mixin.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as RX;

class CreateWalletPasswordController extends GetxController with PasswordMixin {
  final RxString _password = ''.obs;
  final RxString _confirmPassword = ''.obs;
  final Rx<ErrorStatus> _errorStatus = Rx(ErrorStatus.basic);

  late Stream<bool> _isSamePassword;

  final Rx<FormStatus> passwordFormStatus = Rx(FormStatus.empty);
  final Rx<FormStatus> confirmPasswordFormStatus = Rx(FormStatus.empty);
  final RxBool isEnableNext = false.obs;
  final Rx<ErrorStatus> errorMsg = Rx(ErrorStatus.basic);

  void initSamePasswordStream() {
    _isSamePassword = RX.CombineLatestStream.combine2<String, String, bool>(_password.stream, _confirmPassword.stream, (a, b) => a == b);
  }

  Stream<bool> isEnableNextStep() {
    return RX.CombineLatestStream.combine2<FormStatus, bool, bool>(passwordFormStatus.stream, _isSamePassword, (status, isSame) {
      setErrorState(status, _errorStatus.value, isSame: isSame);
      return status == FormStatus.sufficient && isSame;
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
    initSamePasswordStream();
    isEnableNextStep().listen((isEnableNext) {
      this.isEnableNext.value = isEnableNext;
    });
    _errorStatus.listen((event) {
      errorMsg.value = event;
    });
  }

  void updatePassword(String password) {
    _password.value = password;
    passwordFormStatus.value = verifyPassword(password);
  }

  void updateConfirmPassword(String password) {
    _confirmPassword.value = password;
    confirmPasswordFormStatus.value = verifyPassword(password);
  }

  void nextStep() {
    print("go!!!!!!!!!!!!!!!!");
    if (isEnableNext.value) {
      Get.offNamed(Routes.createWallet, arguments: {'password': _password.value});
    } else {
      showToastPopup('비밀번호를 다시 확인해주세요.');
    }
  }
}
